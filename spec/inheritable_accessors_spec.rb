require 'spec_helper'

describe InheritableAccessors do
  it 'has a version number' do
    expect(InheritableAccessors::VERSION).not_to be nil
  end

  context "InheritableHash" do
    it 'should not mutate original object' do
      hash = InheritableAccessors::InheritableHash.new
      hash[:foo] = "test"

      copy = hash.inherit_copy

      expect(copy[:foo]).to eq("test")

      copy[:foo] = "bar"
      expect(copy[:foo]).to eq("bar")
      expect(hash[:foo]).to eq("test")

    end

    it "should allow hash#delete" do
      hash = InheritableAccessors::InheritableHash.new
      hash[:foo] = "test"

      copy = hash.inherit_copy
      copy[:bar] = "test"
      copy.delete(:foo)
      copy.delete(:bar)

      expect(copy.to_hash).to_not have_key(:foo)
      expect(copy.to_hash).to_not have_key(:bar)
    end
  end

  context "InheritableSet" do
    it 'should not mutate original object' do
      set = InheritableAccessors::InheritableSet.new
      set << "test"

      copy = set.inherit_copy

      expect(copy).to include("test")

      copy.merge(["this"])
      expect(set).to_not include("this")
      expect(copy).to include("this")

    end
  end

  context "InheritableAccessors::InheritableHashAccessor" do

    it "should inherit from class, then to instance" do

      parent = Class.new do
        include InheritableAccessors::InheritableHashAccessor

        inheritable_hash_accessor :options

        options[:a] = 1
      end

      child  = Class.new(parent) do
        options[:b] = 2
      end

      grandchild  = Class.new(child) do
        options[:c] = 3
      end

      item = grandchild.new
      item.options[:d] = 4

      expect(item.options.to_hash).to eq({a: 1, b: 2, c: 3, d: 4})
    end
  end
end
