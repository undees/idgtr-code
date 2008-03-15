require 'rubygems'
require 'spec/story'

steps_for :invite do
end

with_steps_for :invite do
  run 'invite_story.txt'
end