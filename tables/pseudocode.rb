fixture.days  = 1
fixture.hours = 47
fixture.mins = 59
fixture.secs = 59 #<callout id="co.secs_writer"/>

passed = (fixture.days == 2)
passed &&= (fixture.hours == 23)
passed &&= (fixture.mins == 59)
passed &&= (fixture.secs == 59)
