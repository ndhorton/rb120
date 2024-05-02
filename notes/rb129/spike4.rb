=begin

### Dental Office Alumni (by Rona Hsu)

There's a dental office called Dental People Inc. 

Within this office, there's 2 oral surgeons, 2 orthodontists, 1 general dentist.
Both general dentists and oral surgeons can pull teeth.
Orthodontists cannot pull teeth.  Orthodontists straighten teeth.
All of these aforementioned specialties are dentists. All dentists graduated from dental school. 
Oral surgeons place implants.
General dentists fill teeth

DentalPeopleInc

dentists
-graduated_dental_school? -> true

oral_surgeon (2)
-place_implant
-pull_tooth

orthodontist (2)
-straighten_teeth

general_dentist (1)
-pull_tooth
-fill_teeth
=end

module Pullable
  def pull_tooth
  end
end

class Dentist
  def graduated_dental_school?
    true
  end
end

class GeneralDentist < Dentist
  include Pullable

  def fill_tooth
  end
end

class OralSurgeon < Dentist
  include Pullable

  def place_implant
  end
end

class Orthodontist < Dentist
  def straighten_teeth
  end
end

class DentalPeopleInc
  def initialize
    @general_dentists = [ GeneralDentist.new ]
    @oral_surgeons = Array.new(2) { OralSurgeon.new }
    @orthodontists = Array.new(2) { Orthodontist.new }
  end
end

# 7m29