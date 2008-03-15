# START:def_api
require 'windows_gui'

describe WindowsGui do                       #<callout id="co.describe"/>
  include WindowsGui
  
  it 'wraps a Windows call with a method' do
    find_window(nil, nil).should_not == 0    #<callout id="co.find_nils"/>
  end

  it 'enforces the argument count' do
    lambda {find_window}.should raise_error  #<callout id="co.lambda"/>
  end
end
# END:def_api


# START:snake_case
describe String, '#snake_case' do
  it 'transforms CamelCase strings' do
    'GetCharWidth32'.snake_case.should == 'get_char_width_32'
  end
  
  it 'leaves snake_case strings intact' do
    'keybd_event'.snake_case.should == 'keybd_event'
  end
end
# END:snake_case