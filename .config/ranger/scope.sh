#!/usr/bin/env bash

set -o noclobber -o noglob -o nounset -o pipefail
IFS=$'\n'

# Dependencies
# ---------------------------
# - GNU coreutils
# - 7z
# - perl
# - pygmentize
# - tar
# - elinks
# - exiftool
# - unrar
# - img2txt
# - jupyter (python package)
# - atool
# - bsdtar
# - transmission
# - odt2txt
# - pdftotext
# - astyle or clang
# - gofmt (part of golang)
# - js-beautify (includes css-beautify and html-beautify)
# - rst2html5.py (ships with the docutils python package)
# - pandoc
# - javap (part of jdk)
# - tree

# If the option `use_preview_script` is set to `true`,
# then this script will be called and its output will be displayed in ranger.
# ANSI color codes are supported.
# STDIN is disabled, so interactive scripts won't work properly

# This script is considered a configuration file and must be updated manually.
# It will be left untouched if you upgrade ranger.

# Meanings of exit codes:
# code | meaning    | action of ranger
# -----+------------+-------------------------------------------
# 0    | success    | Display stdout as preview
# 1    | no preview | Display no preview at all
# 2    | plain text | Display the plain content of the file
# 3    | fix width  | Don't reload when width changes
# 4    | fix height | Don't reload when height changes
# 5    | fix both   | Don't ever reload
# 6    | image      | Display the image  "${IMAGE_CACHE_PATH}"  points to as an image preview
# 7    | image      | Display the file directly as an image

# Script arguments
FILE_PATH="${1}"        # Full path of the highlighted file
PV_WIDTH="${2}"         # Width of the preview pane (number of fitting characters)
PV_HEIGHT="${3}"        # Height of the preview pane (number of fitting characters)
IMAGE_CACHE_PATH="${4}" # Full path that should be used to cache image preview
PV_IMAGE_ENABLED="${5}" # 'True' if image previews are enabled, 'False' otherwise.
EXTENSION="${FILE_PATH#*.}"
FILE_NAME=$(basename "${FILE_PATH}")

[[ -x $(command which elinks 2>/dev/null) ]] && HAS_ELINKS=1 || HAS_ELINKS=0
[[ -x $(command which js-beautify 2>/dev/null) ]] && HAS_JSBEAUTIFY=1 || HAS_JSBEAUTIFY=0

# Settings
if [[ -x $(command which pygmentize 2>/dev/null) ]]; then
  HAS_PYGMENTS=1
  HIGHLIGHT_SIZE_MAX=262143 # 256KiB
  HIGHLIGHT_TABWIDTH=8
  HIGHLIGHT_STYLE=pablo
  PYGMENTIZE_STYLE=autumn
  [[ "$(tput colors)" -ge 256 ]] && PYGMENTIZE_FORMAT=terminal256 || PYGMENTIZE_FORMAT=terminal
else
  HAS_PYGMENTS=0
fi

# most generic, no syntax highlighting
preview() {
  command head -n "${PV_HEIGHT}" -- "${FILE_PATH}" && exit 5 || exit 1
}

preview_go() {
  if [[ -x $(command which go 2>/dev/null) ]]; then
    command gofmt -s <"${FILE_PATH}" | command pygmentize -f "${PYGMENTIZE_FORMAT}" -l golang && exit 5
	else
		command head -n "${PV_HEIGHT}" -- "${FILE_PATH}" | command pygmentize -f "${PYGMENTIZE_FORMAT}" -l golang && exit 5
  fi
}

preview_js() {
  if ((HAS_JSBEAUTIFY)); then
    command head -n "${PV_HEIGHT}" -- "${FILE_PATH}" | command js-beautify | command pygmentize -f "${PYGMENTIZE_FORMAT}" -l javascript && exit 5
  else
    command head -n "${PV_HEIGHT}" -- "${FILE_PATH}" | command pygmentize -f "${PYGMENTIZE_FORMAT}" -l javascript && exit 5
  fi
}

preview_php() {
  command head -n "${PV_HEIGHT}" -- "${FILE_PATH}" | command pygmentize -f "${PYGMENTIZE_FORMAT}" -l html+php
}

preview_css() {
  if ((HAS_JSBEAUTIFY)); then
		command head -n "${PV_HEIGHT}" -- "${FILE_PATH}" | command css-beautify | command pygmentize -f "${PYGMENTIZE_FORMAT}" -l css && exit 5
	else
		command head -n "${PV_HEIGHT}" -- "${FILE_PATH}" | command pygmentize -f "${PYGMENTIZE_FORMAT}" -l css && exit 5
	fi
}

preview_sh() {
  if [[ -x $(command which shfmt 2>/dev/null) ]]; then
    shfmt -s -i2 -ci <"${FILE_PATH}" | command pygmentize -f "${PYGMENTIZE_FORMAT}" -l sh && exit 5
	else
		command head -n "${PV_HEIGHT}" -- "${FILE_PATH}" | command pygmentize -f "${PYGMENTIZE_FORMAT}" -l sh && exit 5
	fi
}

preview_class() {
  if [[ -x $(command which javac 2>/dev/null) ]]; then
    command javap "${FILE_PATH}" | pygmentize -l java
  fi
}

preview_rst() {
  if [[ -x $(command which rst2html5.py 2>/dev/null) ]]; then
    command head -n "${PV_HEIGHT}" "${FILE_PATH}" | rst2html5.py --math-output=LaTeX --link-stylesheet --quiet --smart-quotes=yes --stylesheet=${HOME}/.docutils/docutils.css | command elinks -no-references -no-numbering -dump -dump-color-mode 1 -dump-width "${PV_WIDTH}" && exit 5
	else
    command head -n "${PV_HEIGHT}" "${FILE_PATH}" | command pygmentize -f "${PYGMENTIZE_FORMAT}" -l rst && exit 5
  fi
}

preview_md() {
  [[ -x $(command which pandoc 2>/dev/null) ]] && HAS_PANDOC=1 || HAS_PANDOC=0
  if ((HAS_PANDOC)); then
    command head -n "${PV_HEIGHT}" "${FILE_PATH}" | command pandoc --self-contained -f markdown_github -t html | command elinks -no-references -no-numbering -dump -dump-color-mode 1 -dump-width "${PV_WIDTH}" && exit 5 || exit 1
	else
    command head -n "${PV_HEIGHT}" "${FILE_PATH}" | command pygmentize -f "${PYGMENTIZE_FORMAT}" -l markdown && exit 5
  fi
}

preview_jupyter() {
  if [[ -x $(command which jupyter 2>/dev/null) ]]; then
    command jupyter nbconvert --stdout --to html "${FILE_PATH}" | command elinks -no-references -no-numbering -dump -dump-color-mode 1 -dump-width "${PV_WIDTH}" && exit 5
	else 
		preview_json
  fi
}

preview_html() {
  command elinks -dump -no-references -no-numbering -dump-color-mode 1 -dump-width "${PV_WIDTH}" "${FILE_PATH}" && exit 5
}

preview_img() {
  img2txt --gamma=0.6 --width="${PV_WIDTH}" -- "${FILE_PATH}" && exit 5
  exiftool "${FILE_PATH}" && exit 5
  exit 1
}

preview_xml() {
  if ((HAS_JSBEAUTIFY)); then
    command head -n "${PV_HEIGHT}" -- "${FILE_PATH}" | command html-beautify | command pygmentize -f "${PYGMENTIZE_FORMAT}" -l xml
  else
    command head -n "${PV_HEIGHT}" -- "${FILE_PATH}" | command pygmentize -f "${PYGMENTIZE_FORMAT}" -l xml
  fi
}

preview_dosini() {
  command head -n "${PV_HEIGHT}" -- "${FILE_PATH}" | command pygmentize -f "${PYGMENTIZE_FORMAT}" -l dosini && exit 5
}

preview_docx() {
	# unzip, strip tags
	if [[ -x $(command which unzip 2>/dev/null) ]]; then
		command unzip -p "${FILE_PATH}" word/document.xml | command sed -e 's/<\/w:p>/\n\n/g; s/<[^>]\{1,\}>//g; s/[^[:print:]\n]\{1,\}//g' | command fmt -u -w "${PV_WIDTH}" | command head -n ${PV_HEIGHT} && exit 5 
		exit 1
	fi
}

preview_cfamily() {
  local filetype=$(pygmentize -N "${FILE_PATH}")
  if [[ -x $(command which astyle 2>/dev/null) ]]; then
    command astyle --mode="${filetype}" <"${FILE_PATH}" | command pygmentize -f "${PYGMENTIZE_FORMAT}" -l "${filetype}" && exit 5
  elif [[ -x $(command which clang 2>/dev/null) ]]; then
    command clang-format <"${FILE_PATH}" | command pygmentize -f "${PYGMENTIZE_FORMAT}" -l "${filetype}" && exit 5
  else
    command pygmentize -f "${PYGMENTIZE_FORMAT}" -l "${filetype}" && exit 5
  fi
}

preview_json() {
  if ((HAS_JSBEAUTIFY)); then
    command head -n "${PV_HEIGHT}" -- "${FILE_PATH}" | command js-beautify | command pygmentize -f "${PYGMENTIZE_FORMAT}" -l json && exit 5
  else
    command head -n "${PV_HEIGHT}" -- "${FILE_PATH}" | command pygmentize -f "${PYGMENTIZE_FORMAT}" -l json && exit 5
  fi
}

preview_dir() {                     
	if [[ -d ${FILE_PATH} ]]; then
		if [[ -x $(command which tree 2>/dev/null) ]]; then
			command tree -l -a --prune -L 4 -F --sort=mtime "${FILE_PATH}" && exit 5
		else
			command ls "${FILE_PATH}" -1log
		fi 
	fi
}

preview_csv(){
	command head -n "${PV_HEIGHT}" "${FILE_PATH}" | column --separator ',' --table --output-width ${PV_HEIGHT} --output-separator '  ' && exit 5
	exit 1
}

preview_sqlite(){
	if [[ -x $(command which sqlite3 2>/dev/null) ]]; then
		IFS=$' \n'
		echo -e "\nPreview of SQLite3 database ${FILE_NAME}\n"
		for table_name in $(command sqlite3 --init '' --noheader "${FILE_PATH}" .tables | xargs); do
			command sqlite3 -column -header -init '' "${FILE_PATH}" 'SELECT * FROM '"${table_name} LIMIT 3"
			echo -e "\n"
		done
		exit 5
	fi
}

preview_pptx(){
	echo -e $(basename "${FILE_PATH}")"\n----------------------------------------------------\n"
	command unzip -p "${FILE_PATH}" | command sed -e 's/<\/w:p>/\n\n/g; s/<[^>]\{1,\}>//g; s/[^[:print:]\n]\{1,\}//g' | perl -pe 's/[^[:ascii:]]//g' | fmt -u -w "${PV_WIDTH}" | column | sed -E -e 's/\. ([A-Z])|(\*)|(\-)/\n\n\1/g' && exit 5
	exit 1
}

guess_shebang(){
      # guess from shebang
      if [[ $(head -n 1 "${FILE_PATH}") =~ '#!/' ]]; then
        command head -n "${PV_HEIGHT}" -- "${FILE_PATH}" | command pygmentize -f "${PYGMENTIZE_FORMAT}" -l $(head -n 1 "${FILE_PATH}" | grep -Eo '\w+$') && exit 5
      fi
}

preview_pdf(){
	# Preview as text conversion
	command pdftotext -l 5 -nopgbrk -q -- "${FILE_PATH}" - && exit 5
	command exiftool "${FILE_PATH}" && exit 5
	exit 1
}

handle_code() {

  # save time,
  # don't attempt to render non-text files,
  # don't attempt to pygmentize without it installed
  ! ((HAS_PYGMENTS)) && return
	! [[ $(command file --dereference --brief -- "${FILE_PATH}") =~ text|(xml|script)$ ]] && return

  case "${EXTENSION}" in

    java | cpp | c | h | hpp | cs | c++ | hh | hxx | cp)
      preview_cfamily
      ;;

    json | map)
      preview_json
      ;;

    js | ts)
      preview_js
      ;;

    sh)
      preview_sh
      ;;

    # PHP
    php)
      preview_php
      ;;

    css)
      preview_css
      ;;

		# XML formats
    xml | iml | ?cls | plist | back | xbel | fo | urdf | sdf | xacro | uml | aird | notation | project | svg)
      preview_xml
      ;;

    puml)
      command head -n "${PV_HEIGHT}" -- "${FILE_PATH}" | command pygmentize -f "${PYGMENTIZE_FORMAT}" -l java && exit 5
      exit 1
      ;;

    go)
      preview_go
      ;;

  esac
}

handle_extension() {

  case "${EXTENSION}" in

    csv)
      preview_csv
      ;;

		pdf)
			preview_pdf
			;;


    docx)
			preview_docx
      ;;

    pptx)
			preview_pptx
      ;;


    sqlite | sqlite*)
			preview_sqlite
      ;;

    # automatically decompile Java's *.class files + highlight
    class)
      preview_class
      ;;

    # OpenDocument
    odt | ods | odp | sxw)
      # Preview as text conversion
      command odt2txt "${FILE_PATH}" && exit 5
      exit 1
      ;;

    # BitTorrent
    torrent)
      command transmission-show -- "${FILE_PATH}" && exit 5
      exit 1
      ;;

  esac
}

handle_website() {
  ! ((HAS_ELINKS)) && return

  case "${EXTENSION}" in

    md | m*down)
      preview_md
      ;;

    rst)
      preview_rst
      ;;

    # HTML
    *html)
      preview_html
      ;;

    *ipynb)
      preview_jupyter
      ;;

  esac
}

handle_mime() {

  case $(command file --dereference --brief --mime-type -- "${FILE_PATH}") in

    # Text files
    text/* | application/*xml | application/*script)

      if ! ((HAS_PYGMENTS)); then
        preview
        return
      fi

			guess_shebang

      case "${FILE_NAME,,}" in

				requirements.txt | humans.txt | robots.txt)
					preview_dosini
				;;

				# Generic text files
				*.txt)
					preview
				;;

        .babelrc | .csslintrc | .jsbeautifyrc | .jshintrc | .stylelintrc | .tern-* | .markdownlintrc)
          preview_json
          ;;

        *.conf | *config | *.cfg | .*ignore* | *.cnf | *.toml | *.MF | *.desktop | .flake8 | *.yapf)
          preview_dosini
          ;;

        .*rc)
          if [[ $(pygmentize -N "${FILE_PATH}") =~ text ]]; then
            preview_dosini
          fi
          ;;

        license | readme | change* | contrib* | building | roadmap)
          preview_rst
          ;;

        .ideavimrc)
          command pygmentize -f "${PYGMENTIZE_FORMAT}" -l vim "${FILE_PATH}" && exit 5
          ;;

        .spacemacs | .emacs)
          command pygmentize -f "${PYGMENTIZE_FORMAT}" -l lisp "${FILE_PATH}" && exit 5
          ;;

        pkgbuild | .profile | .zprofile | .zenv | .zsh*)
          preview_sh
          ;;

        *.cabal)
          command pygmentize -f "${PYGMENTIZE_FORMAT}" -l haskell "${FILE_PATH}" && exit 5
          ;;

      esac

      # let pygments guess
      local guess=$(pygmentize -N "${FILE_PATH}")

      if [[ $guess == 'text' ]]; then
        preview
      else
        command head -n "${PV_HEIGHT}" -- "${FILE_PATH}" | command pygmentize -f "${PYGMENTIZE_FORMAT}" -l $guess && exit 5
      fi

      ;;

    inode/directory)
      preview_dir
      ;;

    # Image
    image/*)
      preview_img
      ;;
  esac
}

handle_archive() {

  case "${EXTENSION}" in

    zip | gz | tar | jar | 7z | bz2 | rpm | deb | cpio | deb | arj)

      [[ -x $(command which 7z 2>/dev/null) ]] && HAS_7Z=1 || HAS_7Z=0

      # Avoid password prompt by providing empty password
      ((HAS_7Z)) && command 7z l -p -- "${FILE_PATH}" && exit 5
      ;;

    a | ace | alz | arc | arj | bz | cab | lha | lz | lzh | lzma | lzo | rz | t7z | tbz | tbz2 | tgz | tlz | txz | tZ | tzo | war | xpi | xz | Z)
      command atool --list -- "${FILE_PATH}" && exit 5
      command bsdtar --list --file "${FILE_PATH}" && exit 5
      ;;

    tar.gz)
      command tar ztf "${FILE_PATH}" && exit 5
      ;;

    tar.xz)
      command tar Jtf "${FILE_PATH}" && exit 5
      ;;

    tar.bz2)
      command tar jtf "${FILE_PATH}" && exit 5
      ;;

    rar)
      # Avoid password prompt by providing empty password
      command unrar lt -p- -- "${FILE_PATH}" && exit 5
      exit 1
      ;;

  esac
}

handle_fallback() {
	echo ""
  exiftool "${FILE_PATH}" 
	echo -e "\n${FILE_PATH}\n" && command file --dereference --brief -- "${FILE_PATH}" | command fmt -u -w "${PV_WIDTH}" && exit 5
}

handle_code
handle_website
handle_archive
handle_mime
handle_extension
handle_fallback

exit 1
# vim: nowrap
