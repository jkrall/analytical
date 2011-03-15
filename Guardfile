# A sample Guardfile
# More info at http://github.com/guard/guard#readme

guard 'rspec', :version => 1 do
  watch(/^spec\/(.*)_spec.rb/)
  watch(/^spec\/spec_helper.rb/)                        { "spec" }
  watch(/^lib\/(.*)\.rb/)                               { |m| "spec/lib/#{m[1]}_spec.rb" }
end
