#!/bin/bash

bwrap_sandbox="bwrap \
--ro-bind /usr/bin /usr/bin \
--ro-bind /usr/share /usr/share \
--ro-bind /usr/lib /usr/lib \
--ro-bind /usr/lib64 /usr/lib64 \
--symlink /usr/bin /bin \
--symlink /usr/bin /sbin \
--symlink /usr/lib /lib \
--symlink /usr/lib64 /lib64 \
--tmpfs /usr/lib/modules \
--tmpfs /usr/lib/systemd \
--tmpfs /usr/lib/gcc \
--proc /proc \
--tmpfs /tmp \
--tmpfs /run \
--dev /dev/ \
--dev-bind /dev /dev \
--dir /home/sandbox \
--chdir /home/sandbox \
--ro-bind /etc/profile /etc/profile \
--ro-bind /etc/bash.bashrc /etc/bash.bashrc \
--ro-bind /etc/passwd /etc/passwd \
--ro-bind /etc/group /etc/group \
--ro-bind /etc/hosts /etc/hosts \
--ro-bind /etc/localtime /etc/localtime \
--ro-bind /etc/nsswitch.conf /etc/nsswitch.conf \
--ro-bind /etc/resolv.conf /etc/resolv.conf \
--ro-bind /etc/xdg /etc/xdg \
--ro-bind /etc/X11 /etc/X11 \
--ro-bind /etc/gtk-2.0 /etc/gtk-2.0 \
--ro-bind /etc/gtk-3.0 /etc/gtk-3.0 \
--ro-bind /etc/fonts /etc/fonts \
--ro-bind /etc/mime.types /etc/mime.types \
--ro-bind /usr/share/alsa /usr/share/alsa \
--ro-bind /var/lib/dbus/machine-id /var/lib/dbus/machine-id \
--setenv HOME /home/sandbox \
--setenv USER nobody \
--setenv LOGNAME nobody \
--setenv XAUTHORITY /home/sandbox/.Xauthority \
--setenv SHELL /bin/false \
--setenv DISPLAY :10 \
--unsetenv SUDO_USER \
--unsetenv SUDO_UID \
--unsetenv SUDO_GID \
--unsetenv SUDO_COMMAND \
--unsetenv OLDPWD \
--unsetenv MAIL \
--unshare-pid \
--unshare-cgroup \
--unshare-uts \
--hostname host \
--new-session \
--cap-drop all \
--ro-bind /sys /sys \
"

xephyr_sandbox="bwrap \
--dev-bind / / \
--unshare-pid \
--unshare-uts \
--unshare-cgroup \
--unshare-ipc \
--proc /proc/ \
--tmpfs /tmp/ \
--dev /dev/ \
--new-session \
--setenv SHELL /bin/false \
--cap-drop all \
"

# Exit if no program is given.
if [[ "${@}" = "" ]]; then
  echo "ERROR: No program was supplied."
  exit 1
fi

# Start Xephyr sandbox.
${xephyr_sandbox} /usr/bin/Xephyr -ac :10 &>/dev/null &

# Change size of Xephyr window.
sleep 2
xrandr --display :10 --output default --mode 1400x1050 &>/dev/null

# Start sandbox.
${bwrap_sandbox} ${@}