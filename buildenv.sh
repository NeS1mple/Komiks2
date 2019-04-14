#!/bin/sh

DESTDIR=`pwd`
VENV=${DESTDIR}/.env
PIP=${VENV}/bin/pip
REQ_PKG=${DESTDIR}/requirements.txt
NAME=$0
PIPARGS="install --upgrade"

OSTYPE="`uname`"


install()
{
    echo Creating environment
    if [ "$#" -gt 0 ] && [ "$1" == '2.7' ]; then
        echo Using python 2.7
        virtualenv -v --no-site-packages ${VENV}
        ln -s ${VENV}/bin/python ${DESTDIR}/python
        ln -s ${VENV}/bin/pip ${DESTDIR}/pip

    else
        echo Using python 3.5
        echo If you want to use 2.7 instead use argument \'2.7\'
        python3.5 -m venv --copies ${VENV}

    fi

    ${PIP} ${PIPARGS} pip
    ${PIP} ${PIPARGS} setuptools

    if [[ "$OSTYPE" =~ ^Darwin ]]
    then
        env ARCHFLAGS="-arch x86_64" LDFLAGS="-L/opt/local/lib" CFLAGS="-I/opt/local/include" \
            ${PIP} ${PIPARGS} -r ${REQ_PKG}
    else
            ${PIP} ${PIPARGS} -r ${REQ_PKG}
    fi
}

uninstall()
{
    if [ -d ${VENV} ]
    then
        echo "Remove virtualenv folder"
        rm -rfv ${VENV}
    fi

    if [ -L ${DESTDIR}/python ]
    then
        echo "Remove virtualenv python symlink"
        rm -v ${DESTDIR}/python
    fi

    if [ -L ${DESTDIR}/pip ]
    then
        echo "Remove virtualenv pip symlink"
        rm -v ${DESTDIR}/pip
    fi
}

download()
{
    if [ -z $1 ]
    then
        echo "ERROR... Usage: $NAME download path_to_download_modules"
        exit 1
    fi

    if [ ! -d $1 ]
    then
        mkdir -p -v $1
    fi

    pip -v install --download=$1 -r ${REQ_PKG}
}

display_help()
{
    echo "\n"
    echo "Usage: $NAME {download|install|uninstall|help}" >&2
    echo "Example usage:"
    echo "  download requirements: sh buildenv.sh download /tmp/distfiles/"
    echo "  install virtualenv from network: sh buildenv.sh install"
    echo "  uninstall virtualenv: sh buildenv.sh uninstall"
    echo "\n"
}

case "$1" in
    download)
        download $2
    ;;
    install)
        install $2
    ;;
    uninstall)
        uninstall
    ;;
    help)
        display_help
    ;;
    *)
        display_help
esac

exit 0
