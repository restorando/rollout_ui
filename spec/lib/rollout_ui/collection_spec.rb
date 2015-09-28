require 'spec_helper'

describe RolloutUi::Collection do

  before do
    $rollout.define_id_collection(:my_collection)

    @collection = RolloutUi::Collection.new(:my_collection)
  end

  describe "#users" do
    it "returns an empty array when there are no users for the collection" do
      $redis.del('collection:my_collection')
      expect(@collection.user_ids).to be_empty
    end

    it "returns the users for the collection" do
      $rollout.define_id_collection(:my_collection, [5])
      expect(@collection.user_ids).to eq %w[5]
    end
  end

  describe "#users=" do
    it "sets the users for the collection" do
      @collection.user_ids = [5, "7", ""]
      expect(RolloutUi::Collection.new(:my_collection).user_ids).to have(2).items
      expect(RolloutUi::Collection.new(:my_collection).user_ids).to include("5")
      expect(RolloutUi::Collection.new(:my_collection).user_ids).to include("7")
    end
  end
end
