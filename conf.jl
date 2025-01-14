using REPL.TerminalMenus
using Base: AbstractCmd

@enum Action zshrc bashrc fish dnfconf pacmanconf flathub ssh_askpass

"""
Construct a new command object that wraps over `Cmd` and `pipeline`. This allows
for conveniant silencing output, error throwing on non-zero exit or adding sudo.
"""
function buildcmd(
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
    install_cmd::AbstractCmd
end

# install(man::PkgManager, packages...) = `$(man.install_cmd) $(join(collect(packages), ","))`

_instances(::Type{PkgManager}) = Dict(
    :apt => `apt install`,
    :dnf => `dnf install`,
    :pacman => `pacman -Sy`
)

function PkgManager()::Union{PkgManager,Nothing}
    for (p, install_cmd) in _instances(PkgManager)
        cmd = buildcmd(`which $p`, quiet=true)
        run(cmd).exitcode == 0 && return PkgManager(p, install_cmd)
    end
    nothing
end

function setup_zshrc()
    # copy .zshrc
    cmd = buildcmd(`cp -vir .zshrc $(homedir())/.zshrc`)
    if run(cmd).exitcode == 1
        @warn "zshrc - cancelled."
        return
    end

    # install powerlevel10k
    cmd = buildcmd(`cp -vrf .local/share/powerlevel10k $(homedir())/.local/share/`)
    if run(cmd).exitcode == 1
        @warn "powerlevel10k - cancelled."
        return
    end

    # copy .p10k.zsh
    cmd = buildcmd(`cp -v .p10k.zsh $(homedir())/`)
    if run(cmd).exitcode == 1
        @warn "p10k.zsh - cancelled."
    end
end

function setup_bashrc()
    cmd = buildcmd(`cp -vir .bashrc $(homedir())/.bashrc`)
    if run(cmd).exitcode == 1
        @warn "bashrc - cancelled."
    end
end

function setup_fish()
    cmd = buildcmd(`cp -vrf .config/fish/ $(homedir())/.config/`)
    if run(cmd).exitcode == 1
        @warn "fish - cancelled."
    end
end

function setup_dnfconf()
    cmd = buildcmd(`cp -vir ./etc/dnf/dnf.conf /etc/dnf/dnf.conf`, sudo=true)
    if run(cmd).exitcode == 1
        @warn "dnfconf - cancelled."
    end
end

function setup_pacmanconf()
    cmd = buildcmd(`cp -vir ./etc/pacman.conf /etc/pacman.conf`, sudo=true)
    if run(cmd).exitcode == 1
        @warn "pacmanconf - cancelled."
    end
end

function setup_flathub(man::PkgManager)
    # install flatpak
    cmd = buildcmd(`which flatpak`, quiet=true)
    if run(cmd).exitcode == 0
        @info "flatpak already installed."
    else
        run(buildcmd(`$(man.install_cmd) flatpak`, sudo=true))
    end

    # add flathub
    try
        run(pipeline(`flatpak remotes`, `grep -q flathub`))
        @info "remote flathub already exists."
    catch
        cmd = buildcmd(
            `flatpak --user remote-add flathub https://dl.flathub.org/repo/flathub.flatpakrepo`,
            quiet=true,
        )
        run(cmd).exitcode == 0 && println("added flathub.")
    end
end

function setup_ssh_askpass()
    run(buildcmd(`cp -vir .config/environment.d/ $(homedir())/.config/`))
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
            a == fish && setup_fish()
            a == dnfconf && setup_dnfconf()
            a == pacmanconf && setup_pacmanconf()
            a == flathub && setup_flathub(pkg_manager)
            a == ssh_askpass && setup_ssh_askpass()
        catch
            println()
        end
    end
end
