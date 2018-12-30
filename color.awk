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


    # black
    cmd = "tput setab 0";
    cmd | getline array["blackb"];
    close(cmd);
    # red
    cmd = "tput setab 1";
    cmd | getline array["redb"];
    close(cmd);
    # green
    cmd = "tput setab 2";
    cmd | getline array["greenb"];
    close(cmd);
    # yellow
    cmd = "tput setab 3";
    cmd | getline array["yellowb"];
    close(cmd);
    # blue
    cmd = "tput setab 4";
    cmd | getline array["blueb"];
    close(cmd);
    # magenta
    cmd = "tput setab 5";
    cmd | getline array["magentab"];
    close(cmd);
    # cyan
    cmd = "tput setab 6";
    cmd | getline array["cyanb"];
    close(cmd);
    # white
    cmd = "tput setab 7";
    cmd | getline array["whiteb"];
    close(cmd);


}
BEGIN {
    set_cols(c)
}
