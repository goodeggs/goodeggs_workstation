pushd `pwd`
if rvm --version 2>/dev/null; then
  gem install soloist
else
  sudo gem install soloist
fi

mkdir -p ~/cookbooks; cd ~/cookbooks
cat > soloistrc <<EOF
cookbook_paths:
- $PWD
recipes:
- goodeggs_workstation::meta_osx_base
- goodeggs_workstation::meta_osx_development

node_attributes:
  workspace_directory: "Projects"
  rvm:
    rubies:
      ruby-1.9.3-p194: {}
    default_ruby: ruby-1.9.3-p194
  nvm:
    nodes:
      v0.10.5: {}
    default_node: v0.10.5
  git_pairs_authors: [
    {initials: "ah", name: "Adam Hull", shortname: "adam"},
    {initials: "ag", name: "Alex Gorbatchev", shortname: "alex"},
    {initials: "as", name: "Alon Salant", shortname: "alon"},
    {initials: "bz", name: "Bob Zoller", shortname: "bob"},
    {initials: "bn", name: "Brian Ng", shortname: "brian"},
    {initials: "rp", name: "Randy Puro", shortname: "randy"},
    {initials: "mb", name: "Matt Blair", shortname: "matt"},
    {initials: "me", name: "Max Edmands", shortname: "max"},
    {initials: "ab", name: "Aaron Borden", shortname: "aaron"}
  ]

EOF

if [[ -d dmg ]]; then
  cd dmg && git pull && cd ..
else
  git clone https://github.com/opscode-cookbooks/dmg.git
fi

if [[ ! -d homebrew ]]; then
  git clone git://github.com/opscode-cookbooks/homebrew.git
fi

cd homebrew
git checkout .
git pull
git apply <<EOF
diff --git a/libraries/homebrew_package.rb b/libraries/homebrew_package.rb
index 2d5953d..8105cd7 100644
--- a/libraries/homebrew_package.rb
+++ b/libraries/homebrew_package.rb
@@ -40,7 +40,7 @@ class Chef
 
         protected
         def brew(*args)
-          get_response_from_command("brew #{args.join(' ')}")
+          get_response_from_command("su #{node['current_user']} -c 'brew #{args.join(' ')}'")
         end
 
         def current_installed_version

EOF
cd ..

if [[ -d pivotal_workstation ]]; then
  cd pivotal_workstation && git pull && cd ..
else
  git clone https://github.com/pivotal/pivotal_workstation.git
fi

if [[ -d goodeggs_workstation ]]; then
  cd goodeggs_workstation && git pull && cd ..
else
  git clone https://github.com/goodeggs/goodeggs_workstation.git
fi

soloist
popd
