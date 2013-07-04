require 'spec_helper'


feature 'Basics', :js => true do

  
  scenario "should only show activities for the selected seasons", :slow do
    visit "/"
    set_home()
    find('#search-far').click
    find('#search-far').click
    find('#search-far').click
    page.should have_css(schatzalp_id)
    page.should have_css(regensburg_id)
    uncheck('Winter')
    page.should have_no_css(regensburg_id)
    page.should have_css(schatzalp_id)
    uncheck('Summer')
    page.should have_css(schatzalp_id)
    uncheck('Autumn')
    page.should have_no_css(schatzalp_id)
  end

  scenario "filter by categories", :slow do
    # remove any activities that include unchecked categories

    visit "/"
    set_home()
    find('#search-far').click
    find('#search-far').click
    find('#search-far').click
    page.should have_css(schatzalp_id)
    page.should have_css(regensburg_id)
    uncheck('Hiking')
    page.should have_no_css(schatzalp_id)

  end

  scenario 'listed is filtered based on distance', :slow do
    # not sure how to avoid calling the map info in the test
    # so will just skip this test in case there is no map.
    visit root_path

    # Should land and set home
    set_home()

    # Check correct number of activities shown in index
    page.should have_content('Sledding in Regensberg')
    page.should have_no_css(schatzalp_id)
    page.should have_css(regensburg_id)
    # increase distance filter and check
    find('#search-far').click
    find('#search-far').click
    page.should have_css(schatzalp_id)

    # decrease distance filter and check
    find('#search-close').click
    find('#search-close').click
    page.should have_no_css(schatzalp_id)

    # move home and check
    set_home(46.9, 9.67)  #close to Davos
    page.should have_no_css(regensburg_id)
    page.should have_css(schatzalp_id)

  end

  
  scenario 'visit root and find no selected activities in navbar', :slow do
    visit root_path
    set_home()
    # increase distance in query box so both activities are listed
    find('#search-far').click
    find('#search-far').click
    page.should have_css(schatzalp_id)
    page.should have_css(regensburg_id)


    
    page.execute_script("Ember.testing = true;")
    page.execute_script("Em.run(function(){App.user.set('home', new google.maps.LatLng(46.8, 8.26))});")
    
    navbar_activities = page.all('ul.nav li')
    navbar_activities.length.should == 0
    find(schatzalp_id).click()
    page.should have_content('Activity Detail')
    navbar_activities = page.all('ul.nav li')
    navbar_activities.length.should == 1

    click_on('Dt2')
    find(regensburg_id).click()
    navbar_activities = page.all('ul.nav li')
    navbar_activities.length.should == 2

    click_on('Dt2')
    find(regensburg_id).click()
    navbar_activities = page.all('ul.nav li')
    navbar_activities.length.should == 2
  end

  scenario 'visit activity and find it in the navbar', :slow do
    visit '/'
    set_home()

    visit '/#2'
    navbar_activities = page.all('ul.nav li')
    navbar_activities.count.should == 1

    # should not add a duplicate navbar item
    click_on('Dt2')
    find(regensburg_id).click()
    navbar_activities = page.all('ul.nav li')
    navbar_activities.length.should == 1
  end
end