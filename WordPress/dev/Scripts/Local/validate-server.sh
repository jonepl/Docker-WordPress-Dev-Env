SITENAME=$1

if [ -z $SITENAME ];
    echo "$0: Invalid Site name."
    exit 1
fi

SSHINFO=`cat Scripts/Config/$SITENAME/local.config | grep SSHINFO | cut -d \= -f 2`
GITROOTDIR=`cat Scripts/Config/$SITENAME/local.config | grep GITROOTDIR | cut -d \= -f 2`
DEVROOTDIR=`cat Scripts/Config/$SITENAME/local.config | grep DEVROOTDIR | cut -d \= -f 2`
WEBROOTDIR=`cat Scripts/Config/$SITENAME/local.config | grep WEBDIR | cut -d \= -f 2`

SERVERDIRS=($GITROOTDIR $DEVROOTDIR $WEBROOTDIR)

if ssh $SSHINFO stat $GITROOTDIR \> /dev/null 2\>\&1
    then
            echo "Directory $GITROOTDIR exists"
    else
            echo "Directory $GITROOTDIR does not exist"
fi

if ssh $SSHINFO stat $DEVROOTDIR \> /dev/null 2\>\&1
    then
            echo "Directory $DEVROOTDIR exists"
    else
            echo "Directory $DEVROOTDIR does not exist"
fi

if ssh $SSHINFO stat $WEBROOTDIR \> /dev/null 2\>\&1
    then
            echo "Directory $WEBROOTDIR exists"
    else
            echo "Directory $WEBROOTDIR does not exist"
fi
