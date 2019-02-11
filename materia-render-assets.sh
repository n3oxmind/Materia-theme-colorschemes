#!/bin/env bash
#REPO_DIR=$(cd (dirname -n ) && 'pwd')
set -e
SRCDIR=./src
if [ $? -ne 0 ]; then
    echo "Failed to locate src directory. cd to materia dir."
    exit 1
fi
GTKDIR=$SRCDIR/gtk
GTK2DIR=$SRCDIR/gtk-2.0
GTK3_ASSETS_DIR=$GTKDIR/assets
GTK3_ASSETS_SVG=$GTKDIR/assets.svg
GTK3_ASSETS_IDX=$GTKDIR/assets.txt
GTK2_ASSETS_DIR=$GTK2DIR/assets
GTK2_ASSETS_DARK_DIR=$GTK2DIR/assets-dark
GTK2_ASSETS_SVG=$GTK2DIR/assets.svg
GTK2_ASSETS_DARK_SVG=$GTK2DIR/assets.svg
GTK2_ASSETS_IDX=$GTK2DIR/assets.txt
# Render GTK+ 2 asset
render_asset_gtk2 () {
    local assets_src_file=${1}
    local assets_dir=${2}
    local asset_name=${3}
    local gtk2_hidpi=$(echo ${GTK2_HIDPI-False} | tr '[:upper:]' '[:lower:]')
    local hidpi_option=""
    if [ "gtk2_hidpi" == "true" ]; then
        hidpi_option="--export-dpi=192"
    fi
    INKSCAPE=$(which inkscape)
    OPTIPNG=$(which optipng)
    
    if [ -f ${assets_dir}/${asset_name}.png ]; then
        echo "assets/${asset_name}.png exists."
    else
        echo Rendering assets/${asset_name}.png
        $INKSCAPE --export-id=${asset_name} --export-id-only ${hidpi_option} \
                  --export-background-opacity=0 \
                  --export-png="${assets_dir}/${asset_name}.png" ${assets_src_file} >/dev/null \
        && $OPTIPNG -o7 --quiet ${assets_dir}/${asset_name}.png
    fi
}
# Render GTK+ 3 asset
render_asset_gtk3 () {
    local assets_src_file=${1}
    local assets_dir=${2}
    local asset_name=${3}
    INKSCAPE=$(which inkscape)
    OPTIPNG=$(which optipng)
    
    if [ -f ${assets_dir}/${asset_name}.png ]; then
        echo "assets/${asset_name}.png exists."
    else
        echo Rendering assets/${asset_name}.png
        $INKSCAPE --export-id=${asset_name} --export-id-only \
                  --export-png="${assets_dir}/${asset_name}.png" ${assets_src_file} >/dev/null \
        && $OPTIPNG -o7 --quiet ${assets_dir}/${asset_name}.png
    fi
    if [ -f ${assets_dir}/${asset_name}@2.png ]; then
        echo "assets/${asset_name}@2.png exists."
    else
        echo Rendering assets/${asset_name}@2.png
        $INKSCAPE --export-id=${asset_name} --export-id-only --export-dpi=192 \
                  --export-png="${assets_dir}/${asset_name}@2.png" ${assets_src_file} >/dev/null \
        && $OPTIPNG -o7 --quiet ${assets_dir}/${asset_name}@2.png
    fi
}
is_theme_engine_installed() {
    # Fedora package
    if [ ! $(rpm -qa | grep "gtk-murrine") ]; then
        echo "ERROR: Please installed gtk-murrine-engine"
        echo "Fedora: sudo dnf install gtk-murrine-engine"
        exit 1
    fi
}
# Render assets
render_assets () {
    is_theme_engine_installed
    if [ "$1" == "gtk3" ]; then
        mkdir -p ${GTKDIR}/new_assets
        local assets_src_file=${GTK3_ASSETS_SVG}
        local assets_dir=${GTKDIR}/new_assets
        local assets_index=${GTK3_ASSETS_IDX}
    elif [ "$1" == "gtk2" ]; then
        mkdir -p ${GTK2DIR}/new_assets
        if [[ "${2}" != "-dark" ]]; then
            local assets_src_file=${GTK2_ASSETS_SVG}
        else
            local assets_src_file=${GTK2_ASSETS_DARK_SVG}
        fi
        local assets_dir=${GTK2DIR}/new_assets
        local assets_index=${GTK2_ASSETS_IDX}
    fi
    #install -d ${assets_dir}
    if [[ $(which parallel 2>/dev/null) ]]; then
        printf "\n%s\n\n" "Start rendering ${1} assets..."
        export -f render_asset_${1}
        parallel --no-notice --load 85% --noswap -a ${assets_index} render_asset_${1} ${assets_src_file} ${assets_dir} 
        unset -f render_asset_${1}
        printf "\n%s\n" "Finished rendering ${1} assets."
    else
        printf "\n%s\n" "We recommend installing 'parallel' for faster rendering"
        printf "%s\n" "Start rendering ${1} assets ..."
        while read i; do 
            render_asset_${1} ${assets_src_file} ${assets_dir} "${i}"
        done < ${assets_index}
        printf "\n%s\n\n" "We recommend installing 'parallel' for faster rendering"
        printf "%s\n" "Finished rendering ${1} assets ..."
    fi
}
num_args=$#
#change_assets_color
while [ $# -ne 0 ] && [ "$1" != "--" ]; do
    case "$1" in
        all)
            gtk2color=${2}
            render_assets "gtk2" ${gtk2color}
            render_assets "gtk3"
            shift
            ;;
        gtk2)
            gtk2color=${2}
            render_assets "gtk2" ${gtk2color}
            shift 
            ;;
        gtk3)
            render_assets "gtk3" 
            shift
            ;;
        -light|-dark)
            shift
            ;;
        -h|--help|help)
            echo "usage: $0 gtk2"
            echo "       $0 gtk3"
            echo "       $0 all"
            exit 0
            ;;
        *)
            echo "ERROR: Unrecognized rendering option '$1'."
            echo "Try '$0 help' for more information"
            exit 1
            ;; 
    esac
done
if [ $num_args -eq 0 ]; then
    echo "$0: missing arguments."
    echo "Try '$0 help' for more information"
    exit 1
else
    printf "%s\n" "All assets has been rendered successfully."
fi
exit 0
