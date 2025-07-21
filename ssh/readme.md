

# X11 forwarding
- Make sure server has x11 forwarding set up
    - `which xauth` could be used to check if server is set up
- Make sure client has x11 forwarding set up
    - This depends on the OS of the client, e.g. macOS uses xquartz
- SSH into the server using the -Y (alternatively -X) flag
    - `ssh -Y user@server`
    - Try with the `-v` verbose flag and look for a line with "Requesting X11Forwarding blabla.."
