require File.dirname(__FILE__) + '/../../../spec_helper'

describe SimpleNavigation::Helpers do
  class ControllerMock
    include SimpleNavigation::Helpers
  end

  before(:each) do
    @controller = ControllerMock.new
    SimpleNavigation.stub!(:load_config)
    SimpleNavigation::Configuration.stub!(:eval_config)
    @primary_navigation = stub(:primary_navigation, :null_object => true)
    SimpleNavigation.stub!(:primary_navigation).and_return(@primary_navigation)
    SimpleNavigation.stub!(:config_file? => true)
  end

  describe 'render_navigation' do

    describe 'regarding loading of the config-file' do
      context 'no options specified' do
        it "should load the config-file for the default context" do
          SimpleNavigation.should_receive(:load_config).with(:default)
          @controller.render_navigation
        end
      end

      context 'with options specified' do
        it "should load the config-file for the specified context" do
          SimpleNavigation.should_receive(:load_config).with(:my_context)
          @controller.render_navigation(:context => :my_context)
        end
      end
    end

    it "should eval the config on every request" do
      SimpleNavigation::Configuration.should_receive(:eval_config).with(:default)
      @controller.render_navigation
    end

    describe 'regarding setting of items' do
      context 'not items specified in options' do
        it "should not set the items directly" do
          SimpleNavigation.config.should_not_receive(:items)
          @controller.render_navigation
        end
      end
      context 'items specified in options' do
        before(:each) do
          @items = stub(:items)
        end
        it "should set the items directly" do
          SimpleNavigation.config.should_receive(:items).with(@items)
          @controller.render_navigation(:items => @items)
        end
      end
    end

    describe 'no primary navigation defined' do
      before(:each) do
        SimpleNavigation.stub!(:primary_navigation => nil)
      end
      it {lambda {@controller.render_navigation}.should raise_error}
    end

    context 'rendering of the item_container' do
      before(:each) do
        @active_item_container = stub(:item_container, :null_object => true)
        SimpleNavigation.stub!(:active_item_container_for => @active_item_container)
      end
      it "should lookup the active_item_container based on the level" do
        SimpleNavigation.should_receive(:active_item_container_for).with(:all)
        @controller.render_navigation
      end
      context 'active_item_container is nil' do
        before(:each) do
          SimpleNavigation.stub!(:active_item_container_for => nil)
        end
        it "should not call render" do
          @active_item_container.should_not_receive(:render)
          @controller.render_navigation
        end
      end
      context 'active_item_container is not nil' do
        it "should call render on the container" do
          @active_item_container.should_receive(:render)
          @controller.render_navigation
        end
      end
    end

    context 'primary' do
      it "should call render on the primary_navigation (specifying level through options)" do
        @primary_navigation.should_receive(:render).with(:level => 1)
        @controller.render_navigation(:level => 1)
      end
    end

    context 'secondary' do
      context 'with current_primary_navigation set' do
        before(:each) do
          @selected_item_container = stub(:selected_container, :null_object => true)
          SimpleNavigation.stub!(:active_item_container_for => @selected_item_container)
        end
        it "should find the selected sub_navigation for the specified level" do
          SimpleNavigation.should_receive(:active_item_container_for).with(2)
          @controller.render_navigation(:level => 2)
        end
        it "should find the selected sub_navigation for the specified level" do
          SimpleNavigation.should_receive(:active_item_container_for).with(1)
          @controller.render_navigation(:level => 1)
        end
        it "should call render on the active item_container" do
          @selected_item_container.should_receive(:render).with(:level => 2)
          @controller.render_navigation(:level => 2)
        end
      end
      context 'without an active item_container set' do
        before(:each) do
          SimpleNavigation.stub!(:active_item_container_for => nil)
        end
        it "should not raise an error" do
          lambda {@controller.render_navigation(:level => 2)}.should_not raise_error
        end
      end

    end

    context 'unknown level' do
      it "should raise an error" do
        lambda {@controller.render_navigation(:level => :unknown)}.should raise_error(ArgumentError)
      end
    end
  end

  describe "should treat :level and :levels options the same" do
    before(:each) do
      @selected_item_container = stub(:selected_container, :null_object => true)
      SimpleNavigation.stub!(:active_item_container_for => @selected_item_container)
    end
    it  "should pass a valid levels options as level" do
      @selected_item_container.should_receive(:render).with(:level => 2)
      @controller.render_navigation(:levels => 2)
    end
  end

end