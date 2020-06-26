#!/bin/bash
# What's In It? by Jazz v1.0.12
# Prints a short summary of the content of any directory by listing extensions and the number of files for each type found

BLACK='\e[0;30m'
BLUE='\e[0;34m'
GREEN='\e[0;32m'
CYAN='\e[0;36m'
RED='\e[0;31m'
PURPLE='\e[0;35m'
BROWN='\e[0;33m'
LIGHTGRAY='\e[0;37m'
DARKGRAY='\e[1;30m'
LIGHTBLUE='\e[1;34m'
LIGHTGREEN='\e[1;32m'
LIGHTCYAN='\e[1;36m'
LIGHTRED='\e[1;31m'
LIGHTPURPLE='\e[1;35m'
YELLOW='\e[0;33m'
WHITE='\e[1;37m'
NC='\e[0m'              # No Color

shopt -s extglob # enable extglob whilst running the script in non-interactive shell (enabled by default for interactive one)!
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source "$DIR/inc/spinner.sh" 2> /dev/null

# helper function for _wii_core(): constructing crucial parts of find command
_wii_set_bundle() {
if [ ! -z "${1}" ]
then
  bundle_size="\( -type f -iname \"*.${1//+( )/\" -printf "'"%d %p %s\\n"'" \\) -o \\( -type f -iname \"*.}\" -printf '%d %p %s\\n' \\)" # getting total sizes of each file for a given query
  bundle="\( -type f -iname \"*.${1//+( )/\" \\) -o \\( -type f -iname \"*.}\" \\)" # currently needed for getting a subtree summary for each directory
fi
}


# Main function
_wii_core() {
bundle=0
local s="${1:-0}"       # parameters
local hsize=""
local desc=""
local i=0               # counter of matching directories that contain the queried file type(s)
local start=$(date +%s)

case $s in

  0)
    LIST=$(du --separate-dirs -hc  . | sort -hr | head -50)
    {
      read -r line
      [ $(echo $line | awk '{print $2}') = "total" ] && echo $line | sed 's/ /B /'  # skip parsing the first line from du
      while IFS= read -r line; do
        i=$((i+1))
        hsize=${line%%[[:space:]\t]*} # extracts total size of a subfolder
        relative_path=${line#*[[:space:]]} # extracts subfolder's relative path
        relative_path_edit=${relative_path#\.\/} # hide leading "./"
        num="$((5-${#hsize}))" # hsize + suffix "B" = 6
        space="$(printf "%-${num}s" " ")"
        printf "${RED}${hsize}B${NC}${space}${LIGHTCYAN}${relative_path_edit}${NC}\n"
        find "$relative_path" -maxdepth 1 -type f -name "*.*" | grep -o "[^.]\+$" | sort | uniq -c | sort -k1 -nr
      done
    } <<< "$LIST"
    ;;

  --help | -h)
    i=1 # Don't display a summary
    echo "What's In It? wii v1.0.12 by Jazz"
    echo "Usage: wii.sh [-h] [--image|-i] [--audio|-a] [--video|-v] [--document|-d] [--archive|-r] [--font|-f] [--programming|-p] [extension(s)]"
    echo
    echo "example for using a custom extension: 'wii.sh mp3'"
    echo "example for using multtiple extensions: 'wii.sh php theme module inc js'"
    echo "Extensions (mp3) and predefined parameters (--audio, --video etc.) can not be combined. Keywords have a higher priority than extension(s)."
    echo "Therefore, 'wii.sh -a -v' or 'wii.sh -a doc' will not work, but 'wii.sh mp3 doc' will work as expected."
    ;;

  --image | -i)
    desc=" common image"
    bundle="jpg jpeg png gif bmp tif tiff svg ai webp"
    _wii_set_bundle "${bundle}"
    ;;

  --audio | -a)
    desc=" common audio"
    bundle="mp3 flac m4a mpa aif ogg wav wma dsd dsf dff"
    _wii_set_bundle "${bundle}"
    ;;

  --video | -v)
    desc=" common video"
    bundle="mp4 mov mpg mpeg mkv m4v avi 3gp 3g2 h264 wmv vob"
    _wii_set_bundle "${bundle}"
    ;;

  --document | -d)
    desc=" common document"
    bundle="doc docx xls xlsx rtf ppt pptx pps pdf csv mdb ods odp odt txt"
    _wii_set_bundle "${bundle}"
    ;;

  --archive | -r)
    desc=" common archive"
    bundle="7z rar zip arj deb tar gz z iso"
    _wii_set_bundle "${bundle}"
    ;;

  --font | -f)
    desc=" common font"
    bundle="ttf otf fon fnt"
    _wii_set_bundle "${bundle}"
    ;;

  --programming | -p)
    desc=" common programming"
    bundle="php py css htm html js theme module inc sh"
    _wii_set_bundle "${bundle}"
    ;;

  *)
    prefix="\( -type f -iname \"*."
    suffix="\" \\)"
    suffix_size="\" -printf '%d %p %s\\n' \\)"
    bundle=""
    bundle_size=""
    local param=0
    for var in "$@"
      do
        param=$((param+1))
        [ "$param" -lt $# ] && bundle="${bundle}${var}\" \\) -o \\( -type f -iname \"*." && bundle_size="${bundle_size}${var}\" -printf '%d %p %s\\n' \\) -o \\( -type f -iname \"*." && bundle_size_current="${bundle_size}${var}\" -printf '%d %p %s\\n' \\) -o \\( -type f -iname \"*."
        [ "$param" == $# ] && [ "$param" -gt 1 ] && bundle="${bundle}${var}" && bundle_size="${bundle_size}${var}" && bundle_size_current="${bundle_size_current}${var}"
        [ "$#" == 1 ] && bundle="${var}" && bundle_size="${var}" && bundle_size_current="${var}"
      done
    bundle="${prefix}${bundle}${suffix}"
    bundle_size="${prefix}${bundle_size}${suffix_size}"
    ;;
esac

if [ "$i" != 1 ] # don't proceed if we printed help, or if wii without parameters returned only 1 directory as a result
then
  if [ "$bundle" == 0 ] # there are no parameters?
  then
    echo "Summary: "
    echo "--------"
    find . -type f -iname "*.*" | grep -o "[^.]\+$" | sort | uniq -c | sort -k1 -nr
  else
    i=0
    hsize=0 # file size of current file
    hsize_prev=0 # hsize sum from the previous loop cycle
    all_hsize=0 # hsize of all matches
    printed=0 # tracking status of displaying notifications
    relative_path="" # basename of current file
    relative_path_prev="" # relative path from the previous loop cycle
    relative_path_stack="" # summary of sizes of all folders matching our query
    all_results_stack="" # stack that includes all files found
    file="files" # singular vs plural in notifications
    directory="directories" # singular vs plural in notifications
    LIST=$(echo -e "find . ${bundle_size} | sort -k1 -n" | bash) # main list of all file sizes and paths
    LIST=$(echo -e "${LIST}" | cut -f1 -d" " --complement) # delete the depth indicator (%d) as the first column
    LIST=$(echo -e "${LIST}" | awk '{$0=$NF FS$0;$NF=""}1') # move size column from the last position to the front
    if [ -n "$(echo "$LIST" | head -n 1)" ]; # checking if the previous find command has returned any result
    then
      total_num_lines=$(echo "${LIST}" | wc -l)
      [ "${total_num_lines}" -gt 800 ] && [ "${printed}" -lt 1 ] && printed=1 && echo -e "[${YELLOW}NOTE${NC}] This process may take awhile, so please be patient."
      {
        while IFS= read -r line; do
          i=$((i+1))
          hsize=${line%%[[:space:]\t]*} # read current file size
          relative_path=$(dirname "${line#*[[:space:]]}") # extracts subfolder's relative path
          filename="${line##*/}"
          extension="${filename##*.}"
          [ "$filename" == "$extension" ] && extension=""
          [ ! -z "${relative_path}" ] && [ ! -z "${extension}" ] && all_results_stack="${all_results_stack}${hsize} ${relative_path} ${extension}\n" # create stack of directory names
          if [ "${i}" == 1 ];
          then
            hsize_prev="${hsize}"
            relative_path_prev="${relative_path}"
          else
            if [ "${relative_path_prev}" == "${relative_path}" ];
            then
              hsize_prev=$((hsize_prev+hsize))
            else
              relative_path_stack="${relative_path_stack}${hsize_prev} ${relative_path_prev}\n"
              relative_path_prev="${relative_path}"
              hsize_prev="${hsize}"
            fi
          fi
        done
      } <<< "$LIST"

      if [ "${i}" -gt 0 ]
      then
        relative_path_stack="${relative_path_stack}${hsize_prev} ${relative_path_prev}\n" # add last element to the stack
      fi

      all_results_stack=$(echo "${all_results_stack//\\n/$'\n'}" | sed '/^$/d')
      summary=$(echo -e "${all_results_stack}" | cut -f1 -d" " --complement) # delete the hsize column at the front
      num_lines=$(echo -e "${relative_path_stack}" | wc -l)
      all_hsize=$(echo -e "${all_results_stack}" | awk 'END { print s } { s += $1 }')


      relative_path_stack=$(echo "${relative_path_stack//\\n/$'\n'}" | sort | uniq | sort -k1 -nr | sed '/^$/d' | head -50)
      # display notifications
      [ "${i}" == 1 ] && file="file" # signgular vs plural in notifications
      [ "${num_lines}" == 1 ] && directory="directory"
      [ "${num_lines}" -gt 50 ] && [ "${printed}" -lt 2 ] && printed=2 && echo -e "[${YELLOW}NOTE${NC}] Results will be truncated to display only 50 largest directories!" && echo -en "[${YELLOW}NOTE${NC}] " && printf "%s %s found in %s %s\n\n" "${i}" "${file}" "${num_lines}" "${directory}"
      hsize_hr=$(echo ${all_hsize} | numfmt --to=iec --suffix=B)
    else
      hsize_hr="0B"
    fi

    printf "%s total\n" "${hsize_hr}"

    if [ "$i" -gt 0 ] # do we have any results?
    then
      i=0
      {
        while IFS= read -r line; do
          i=$((i+1))
          hsize=${line%%[[:space:]\t]*} # extracts total size of a subfolder
          hsize_hr=$(echo ${hsize} | numfmt --to=iec --suffix=B)
          relative_path=${line#*[[:space:]]} # extracts subfolder's relative path
          relative_path_edit=${relative_path#\.\/} # hide leading "./"
          num="$((6-${#hsize_hr}))"
          space="$(printf "%-${num}s" " ")"
          printf "${RED}${hsize_hr}${NC}${space}${LIGHTCYAN}${relative_path_edit}${NC}\n"

          # Todo: the following line should be re-created to avoid repetitive execution of find
          printf "find %q -maxdepth 1 %s | grep -o \"[^.]\+$\" | sort | uniq -c | sort -k1 -nr" "${relative_path}" "${bundle}" | bash # subtree summary
        done
      } <<< "${relative_path_stack}"

      if [ "$i" != 1 ] # don't display the summary if only one directory found
      then
        echo "Summary:"
        echo "--------"
        echo -e "${summary}" | awk '{print $NF}' | sort | uniq -c | sort -k1 -nr
      fi

      else
      echo -e "No${desc} files found."
    fi
  fi
fi
end=$(date +%s)
runtime=$((end-start))
[ "${runtime}" -gt 9 ] && echo && printf 'Elapsed time: %dh:%dm:%ds\n' $(($runtime/3600)) $(($runtime%3600/60)) $(($runtime%60))
}


# Wrapper
# Check if the spinner function exists (bash specific)
if declare -f "spinner" > /dev/null && [ "${1}" != "-h" ] && [ "${1}" != "--help" ]
then
  # Call _wii_core in the background with the same arguments, call the spinner
  set +m
  _wii_core "$@" &
  pid=$!
  spinner $pid
  set -m
else
  # Avoid spinner
  _wii_core "$@"
fi
