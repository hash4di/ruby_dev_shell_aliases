function rbenv_install_target_ruby_version() {
  if [ -f .rubocop.yml ]; then
    if (grep -q TargetRubyVersion: < .rubocop.yml); then
      local rbenv_install_target_ruby_version_VERSION
      rbenv_install_target_ruby_version_VERSION=$(grep TargetRubyVersion: < .rubocop.yml | cut -f 2 -d : | cut -b2-)
      cd ~/.rbenv/plugins/ruby-build || return 203
      git pull || git pull || return 204
      cd - || return 205
      local rbenv_install_target_ruby_version_PATCHED_VERSION
      rbenv_install_target_ruby_version_PATCHED_VERSION=$(
        rbenv install --list | grep "  $rbenv_install_target_ruby_version_VERSION" | sort | tail -n 1 | cut -b3-
      )
      if ! (rbenv version | cut -f 1 -d ' ' | grep -q "$rbenv_install_target_ruby_version_PATCHED_VERSION"); then
        if ! (rbenv local "$rbenv_install_target_ruby_version_PATCHED_VERSION") then
          rbenv install "$rbenv_install_target_ruby_version_PATCHED_VERSION"
          rbenv local "$rbenv_install_target_ruby_version_PATCHED_VERSION" || return 206
        fi
      fi
      bi || return 207
    else
      echo "No TargetRubyVersion in .rubocop.yml file. Exiting ..."
      return 202
    fi
  else
    echo "No .rubocop.yml file. Exiting ..."
    return 201
  fi
}
