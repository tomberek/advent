function set_cols(array) {
    # bold
    cmd = "tput bold";
    cmd | getline array["bold"];
    close(cmd);
    # black
    cmd = "tput setaf 0";
    cmd | getline array["black"];
    close(cmd);
    # red
    cmd = "tput setaf 1";
    cmd | getline array["red"];
    close(cmd);
    # green
    cmd = "tput setaf 2";
    cmd | getline array["green"];
    close(cmd);
    # yellow
    cmd = "tput setaf 3";
    cmd | getline array["yellow"];
    close(cmd);
    # blue
    cmd = "tput setaf 4";
    cmd | getline array["blue"];
    close(cmd);
    # magenta
    cmd = "tput setaf 5";
    cmd | getline array["magenta"];
    close(cmd);
    # cyan
    cmd = "tput setaf 6";
    cmd | getline array["cyan"];
    close(cmd);
    # white
    cmd = "tput setaf 7";
    cmd | getline array["white"];
    close(cmd);
    # reset
    cmd = "tput sgr0";
    cmd | getline array["reset"];
    close(cmd);
}
BEGIN {
    set_cols(c)
}
