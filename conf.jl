@enum Action zsh bash fish dnfconf flathub
@enum PkgManager apt dnf pacman

function Cmd(cmd::Base.Cmd; ignorestatus::Bool=false, quiet::Bool=false, sudo::Bool=false)
    cmd = Base.Cmd(cmd, ignorestatus=ignorestatus)
    if sudo
        cmd = `sudo $cmd`
    end
    if quiet
        cmd = pipeline(cmd, stdout=devnull, stderr=devnull)
    end
    cmd
end

function install_cmd(pkg_manager::PkgManager, package)::Cmd
    if pkg_manager == apt || pkg_manager == dnf
        `$pkg_manager install $package`
    elseif pkg_manager == pacman
        `$pkg_manager -Sy $package`
    end
end

install_cmd(pkg_manager::PkgManager, packages...) = install_cmd(pkg_manager, join(collect(packages), ","))

function get_pkgmanager()::Union{PkgManager,Nothing}
    for p in instances(PkgManager)
        cmd = Cmd(`which $p`, ignorestatus=true, quiet=true)
        run(cmd).exitcode == 0 && return p
    end
    nothing
end

function setup_flathub(pkg_manager::PkgManager)
    # install flatpak
    cmd = Cmd(`which flatpak`, ignorestatus=true, quiet=true)
    if run(cmd).exitcode == 0
        @info "flatpak already installed."
    else
        cmd = Cmd(install_cmd(pkg_manager, "flatpak"), ignorestatus=true, sudo=true)
        run(cmd).exitcode == 0 && println("flatpak installed.")
    end

    # add flathub
    try
        run(pipeline(`flatpak remotes`, `grep -q flathub`))
        @info "remote flathub already exists."
    catch
        cmd = Cmd(`flatpak --user remote-add flathub https://dl.flathub.org/repo/flathub.flatpakrepo`, ignorestatus=true, quiet=true)
        run(cmd).exitcode == 0 && println("added flathub.")
    end
end

function setup_dnfconf()
    cmd = Cmd(`cp -vir ./etc/dnf/dnf.conf /etc/dnf/`, ignorestatus=true, sudo=true)
    if run(cmd).exitcode == 0
        println("dnf.conf configured.")
    else
        @info "cancelled."
    end
end

function setup_zsh()
    # setup .zshrc
    cmd = Cmd(`cp -vir .zshrc $(homedir())/.zshrc`, ignorestatus=true)
    if run(cmd).exitcode == 0
        println("zsh configured.")
    else
        @info "cancelled."
    end

    # install powerlevel10k
end
