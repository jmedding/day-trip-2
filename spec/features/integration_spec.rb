require 'spec_helper'


feature 'Basics', :js => true do



  
  scenario 'visit root and find no selected activities in navbar' do
    visit root_path
    
    navbar_activities = page.all('ul.nav li')
    navbar_activities.length.should == 0
    find('#list-item-1').click()
    page.should have_content('Activity Detail')
    navbar_activities = page.all('ul.nav li')
    navbar_activities.length.should == 1

    click_on('Dt2')
    find('#list-item-2').click()
    navbar_activities = page.all('ul.nav li')
    navbar_activities.length.should == 2

    click_on('Dt2')
    find('#list-item-2').click()
    navbar_activities = page.all('ul.nav li')
    navbar_activities.length.should == 2
  end

  scenario 'visit activity and find it in the navbar' do
    visit '/'
    visit '/#1'
    navbar_activities = page.all('ul.nav li')
    navbar_activities.count.should == 1

    # should not add a duplicate navbar item
    click_on('Dt2')
    find('#list-item-1').click()
    navbar_activities = page.all('ul.nav li')
    navbar_activities.length.should == 1
  end
end