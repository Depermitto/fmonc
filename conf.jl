using REPL.TerminalMenus
using Base: AbstractCmd

@enum Action zshrc bashrc fishconf dnfconf pacmanconf flathub ssh_askpass

"""
Construct a new `Cmd` object that wraps over `Base.Cmd` and `Base.pipeline`. This allows
for conveniant silencing output, error throwing on non-zero exit or adding sudo.
"""
function Cmd(
    cmd::Base.Cmd;
    throw_on_error::Bool=false, quiet::Bool=false, sudo::Bool=false
)::AbstractCmd
    if sudo
        cmd = `sudo $cmd`
    end
    cmd = Base.Cmd(cmd, ignorestatus=!throw_on_error)
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
    install_cmd::AbstractCmd
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

function setup_zshrc()
    # copy .zshrc
    cmd = Cmd(`cp -vir .zshrc $(homedir())/.zshrc`)
    if run(cmd).exitcode == 1
        @warn "cancelled."
        return
    end

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
end

function setup_bashrc()
    # copy .bashrc
    cmd = Cmd(`cp -vir .bashrc $(homedir())/.bashrc`)
    if run(cmd).exitcode == 1
        @warn "cancelled."
    end
end

function setup_dnfconf()
    cmd = Cmd(`cp -vir ./etc/dnf/dnf.conf /etc/dnf/dnf.conf`, sudo=true)
    if run(cmd).exitcode == 1
        @warn "cancelled."
    end
end

function setup_flathub(man::PkgManager)
    # install flatpak
    cmd = Cmd(`which flatpak`, quiet=true)
    if run(cmd).exitcode == 0
        @info "flatpak already installed."
    else
        run(Cmd(`$(man.install_cmd) flatpak`, sudo=true))
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

function setup_ssh_askpass()
    run(Cmd(`cp -vir .config/environment.d/ $(homedir())/.config/`))
    nothing
end

function main()
    actions = collect(instances(Action))
    options = map(String ∘ Symbol, actions)
    indexes = request("Select actions to perform:", MultiSelectMenu(options))

    pkg_manager = PkgManager()

    for a in getindex(actions, collect(indexes))
        try
            a == zshrc && setup_zshrc()
            a == bashrc && setup_bashrc()
            a == fishconf && @error "fishconf - not implemented yet."
            a == dnfconf && setup_dnfconf()
            a == pacmanconf && @error "pacmanconf - not implemented yet."
            a == flathub && setup_flathub(pkg_manager)
            a == ssh_askpass && setup_ssh_askpass()
        catch
            println()
        end
    end
end
