function get_pkgmanager()::Union{String,Nothing}
    for p in ["apt", "dnf", "pacman"]
        cmd = Cmd(`which $p`, ignorestatus=true)
        cmd = pipeline(cmd, stdout=devnull, stderr=devnull)
        run(cmd).exitcode == 0 && return p
    end
    nothing
end
