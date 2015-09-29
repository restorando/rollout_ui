require 'spec_helper'

describe "Engine" do
  describe "GET /rollout" do
    let(:user) { mock(:user, :id => 5) }

    before do
      $rollout.active?(:featureA, user)
    end

    it "shows requested rollout features" do
      visit "/rollout"

      page.should have_content("featureA")
    end

    describe "percentage" do
      it "allows changing of the percentage" do
        visit "/rollout"

        within("#featureA .percentage_form") do
          select "100", :from => "percentage"
          click_button "Save"
        end

        $rollout.active?(:featureA, user).should be_true
      end

      it "shows the selected percentage" do
        visit "/rollout"

        within("#featureA .percentage_form") do
          select "57", :from => "percentage"
          click_button "Save"
        end

        page.should have_css(".percentage option[selected='selected']", :text => "57")
      end
    end

    describe "collections" do
      before do
        $rollout.define_id_collection(:my_collection, [5])
      end

      it "allows selecting of collections" do
        visit "/rollout"

        within("#featureA .collections_form") do
          select "my_collection", :from => "collections[]"
          click_button "Save"
        end

        expect($rollout).to be_active(:featureA, user)
      end

      it "shows the selected collection" do
        visit "/rollout"

        within("#featureA .collections_form") do
          select "my_collection", :from => "collections[]"
          click_button "Save"
        end

        expect(page).to have_css(".collections option[selected='selected']", text: "my_collection")
      end
    end

    describe "groups" do
      before do
        user.stub(:beta_tester? => true)
        $rollout.define_group(:beta_testers) { |user| user.beta_tester? }
      end

      it "allows selecting of groups" do
        visit "/rollout"

        within("#featureA .groups_form") do
          select "beta_testers", :from => "groups[]"
          click_button "Save"
        end

        $rollout.active?(:featureA, user).should be_true
      end

      it "shows the selected groups" do
        visit "/rollout"

        within("#featureA .groups_form") do
          select "beta_testers", :from => "groups[]"
          click_button "Save"
        end

        page.should have_css(".groups option[selected='selected']", :text => "beta_testers")
      end
    end

    describe "users" do
      it "allows adding user ids" do
        visit "/rollout"

        within("#featureA .users_form") do
          fill_in "users[]", :with => 5
          click_button "Save"
        end

        $rollout.active?(:featureA, user).should be_true
      end

      it "shows the selected percentage" do
        visit "/rollout"

        within("#featureA .users_form") do
          fill_in "users[]", :with => 5
          click_button "Save"
        end

        page.should have_css("input.users[value='5']")
      end
    end

    describe "order" do
      before do
        $rollout.active?(:featureB, user)
        $rollout.active?(:anotherFeature, user)
      end

      it "shows features in alphabetical order" do
        visit "/rollout"

        elements = %w(anotherFeature featureA featureB)
        page.body.should =~ Regexp.new("#{elements.join('.*')}.*", Regexp::MULTILINE)
      end
    end
  end

  describe 'GET /rollout/collections' do
    before do
      $rollout.define_id_collection(:my_collection)
      $rollout.define_id_collection(:another_collection)
    end

    it 'shows all collections' do
      visit '/rollout/collections'

      expect(page).to have_content('my_collection')
      expect(page).to have_content('another_collection')
    end

  end

  describe 'POST /rollout/collections' do
    it 'creates a new collection' do
      post '/rollout/collections', :collection_name => "my_new_collection"
      visit '/rollout/collections'

      expect(page).to have_content('my_new_collection')
    end
  end

  describe 'PUT /rollout/collections' do

    before do
      $rollout.define_id_collection(:new_collection)
    end

    it 'updates the collection with new users' do
      put '/rollout/collections/new_collection', :users => [ "101", "654" ]
      expect(RolloutUi::Collection.new(:new_collection).user_ids).to eq %w[101 654]
    end
  end

end

