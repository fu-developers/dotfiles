## Functions
function docker_boot {
    docker compose -f ~/docker/$1/docker-compose.yml up -d
}

function docker_stop {
   docker compose -f ~/docker/$1/docker-compose.yml down
}

function common_boot {
   docker compose -f ~/docker/common/mysql/docker-compose.yml up -d
   docker compose -f ~/docker/common/redis/docker-compose.yml up -d
}

function common_stop {
   docker compose -f ~/docker/common/redis/docker-compose.yml down
   docker compose -f ~/docker/common/mysql/docker-compose.yml down
}

# Search for specific file or directory
# Returns the path to first file found or fails
# USAGE:
#    upsearch path1 path2 ...
function upsearch() {
  # Parse CLI options
  zparseopts -E -D \
    s=silent -silent=silent

  local files=("$@")
  local root="$(pwd -P)"

  # Go up to the root
  while [ "$root" ]; do
    # For every file as an argument
    for file in "${files[@]}"; do
      local find_match="$(find $root -maxdepth 1 -name $file -print -quit 2>/dev/null)"
      local filename="$root/$file"
      if [[ -n "$find_match" ]]; then
        [[ -z "$silent" ]] && echo "$find_match"
        return 0
      elif [[ -e "$filename" ]]; then
        [[ -z "$silent" ]] && echo "$filename"
        return 0
      fi
    done

    if [[ -d "$root/.git" || -d "$root/.hg" ]]; then
      # If we reached the root of repo, return non-zero
      return 1
    fi

    # Go one level up
    root="${root%/*}"
  done

  # If we reached the root, return non-zero
  return 1
}

function aws_ssm {
    aws ssm start-session --target $1
}

function getEcrLogin {
    local account_id="$1"
    local region="${2:-${AWS_DEFAULT_REGION:-$(aws configure get region 2>/dev/null)}}"

    if [ -z "$region" ]; then
        echo "No AWS region found. Set AWS_DEFAULT_REGION, use asp (aws plugin) to select a profile, or pass region as second argument."
        return 1
    fi

    aws ecr get-login-password --region "$region" | docker login --username AWS --password-stdin "$account_id.dkr.ecr.$region.amazonaws.com"
}

function git-list-no-remote {
	git branch -r | awk '{print $1}' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print $1}'
}
