#!/bin/sh
notmuch new
# retag all "new" messages "inbox" and "unread"
# notmuch tag +inbox +unread -new -- tag:new
# tag all messages from "me" as sent and remove tags inbox and unread
notmuch tag -inbox +sent -- from:tillbungert@gmail.com or from:bungert@stud.uni-heidelberg.de or from:till.bungert@galileiconsult.de
notmuch tag -inbox +trash -- folder:'/[tT]rash/'

notmuch tag +social -inbox -- \
    from:*linkedin.com or \
    from:*xing.com \

notmuch tag +news -inbox -- \
    from:*massdrop.com or \
    from:*medium.com

NEW=$(notmuch count tag:inbox and not tag:notified)
if [[ $NEW -gt 0 ]]; then
    dunstify --icon="/usr/share/icons/Papirus-Dark/16x16/actions/mail-message.svg" "$NEW new Email(s)"
    notmuch tag +notified -- tag:inbox
fi
