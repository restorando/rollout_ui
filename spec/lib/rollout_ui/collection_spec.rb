require 'spec_helper'

describe RolloutUi::Collection do

  before do
    $rollout.define_id_collection(:my_collection)

    @collection = RolloutUi::Collection.new(:my_collection)
  end

  describe "#users" do
    it "returns an empty array when there are no users for the collection" do
      $redis.del('collection:my_collection')
      @collection.user_ids.should == []
    end

    it "returns the users for the collection" do
      $rollout.define_id_collection(:my_collection, [5])
      @collection.user_ids.should == ["5"]
    end
  end

  describe "#users=" do
    it "sets the users for the collection" do
      @collection.user_ids = [5, "7", ""]
      RolloutUi::Collection.new(:my_collection).user_ids.length.should == 2
      RolloutUi::Collection.new(:my_collection).user_ids.should include("5")
      RolloutUi::Collection.new(:my_collection).user_ids.should include("7")
    end
  end
end
