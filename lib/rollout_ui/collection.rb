module RolloutUi
  class Collection 
    User = Struct.new(:id)

    attr_reader :name

    def initialize(name)
      @wrapper = Wrapper.new
      @name = name.to_sym
    end

    def user_ids
      rollout.ids_from_collection(name.to_sym)
    end

    def user_ids=(ids)
      ids.reject! { |id| id.to_s.empty? }
      rollout.define_id_collection(name, ids)
    end

  private

    def redis
      @wrapper.redis
    end

    def rollout
      @wrapper.rollout
    end

    def group_for(name)
      rollout.instance_variable_get(:@groups).select { |elem| elem == name}.first
    end
  end
end
