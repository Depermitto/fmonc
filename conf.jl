using REPL.TerminalMenus

@enum Action zshrc bashrc fishconf dnfconf pacmanconf kittyconf flathub sshaskpass

"""
Construct a new `Cmd` object that wraps over `Base.Cmd` and `Base.pipeline`. This allows
for conveniant silencing output, error throwing on non-zero exit or adding sudo.
"""
function Base.Cmd(
    cmd::Cmd;
    throw_on_error::Bool=false, quiet::Bool=false, sudo::Bool=false
)::AbstractCmd
    if sudo
        cmd = `sudo $cmd`
    end
    cmd = Cmd(cmd, ignorestatus=!throw_on_error)
    if quiet
        cmd = pipeline(cmd, stdout=devnull, stderr=devnull)
    end
    cmd
end

"""
Representation of a linux package manager. Recommended to construct
using the parameterless constructor.
"""
struct PkgManager
    syspath::Symbol
    install_cmd::Base.Cmd
end

# install(man::PkgManager, packages...) = `$(man.install_cmd) $(join(collect(packages), ","))`

Base.instances(::Type{PkgManager}) = Dict(
    :apt => `apt install`,
    :dnf => `dnf install`,
    :pacman => `pacman -Sy`
)

function PkgManager()::Union{PkgManager,Nothing}
    for (p, install_cmd) in instances(PkgManager)
        cmd = Cmd(`which $p`, quiet=true)
        run(cmd).exitcode == 0 && return PkgManager(p, install_cmd)
    end
    nothing
end

function setup_flathub(man::PkgManager)
    # install flatpak
    cmd = Cmd(`which flatpak`, quiet=true)
    if run(cmd).exitcode == 0
        @info "flatpak already installed."
    else
        cmd = Cmd(`$(man.install_cmd) flatpak`, sudo=true)
        run(cmd).exitcode == 0 && println("flatpak installed.")
    end

    # add flathub
    try
        run(pipeline(`flatpak remotes`, `grep -q flathub`))
        @info "remote flathub already exists."
    catch
        cmd = Cmd(
            `flatpak --user remote-add flathub https://dl.flathub.org/repo/flathub.flatpakrepo`,
            quiet=true,
        )
        run(cmd).exitcode == 0 && println("added flathub.")
    end
end

function setup_zshrc()
    # copy .zshrc
    cmd = Cmd(`cp -vri .zshrc $(homedir())/.zshrc`)
    if run(cmd).exitcode == 1
        @warn "cancelled."
        return
    end
    println("zsh configured.")

    # install powerlevel10k
    cmd = Cmd(`cp -vrf .local/share/powerlevel10k $(homedir())/.local/share/`)
    if run(cmd).exitcode == 1
        @warn "cancelled."
        return
    end

    # copy .p10k.zsh
    cmd = Cmd(`cp -v .p10k.zsh $(homedir())/`)
    if run(cmd).exitcode == 1
        @warn "cancelled."
    end
    println("powerlevel10k configured.")
end

function setup_bashrc()
    # copy .bashrc
    cmd = Cmd(`cp -vri .bashrc $(homedir())/.bashrc`)
    if run(cmd).exitcode == 1
        @warn "cancelled."
        return
    end
    println("bashrc configured.")
end

function setup_dnfconf()
    cmd = Cmd(`cp -vri ./etc/dnf/dnf.conf /etc/dnf/dnf.conf`, sudo=true)
    if run(cmd).exitcode == 0
        println("dnf.conf configured.")
    else
        @warn "cancelled."
    end
end

function main()
    options = collect(map(a -> String(Symbol(a)), instances(Action)))
    indexes = request("Select actions to perform:", MultiSelectMenu(options))
end
