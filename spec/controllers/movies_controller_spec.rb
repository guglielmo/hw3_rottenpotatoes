require 'spec_helper'

describe MoviesController do
  context 'searching TMDb' do
    before :each do
      @fake_results = [mock('movie1'), mock('movie2')]
    end
    it 'should call the models method that performs TMDb search' do
      Movie.should_receive(:find_in_tmdb).with('hardware').
          and_return(@fake_results)
      post :search_tmdb, {:search_terms => 'hardware'}
    end
    context 'after valid search' do
      before :each do
        Movie.stub(:find_in_tmdb).and_return(@fake_results)
        post :search_tmdb, {:search_terms => 'hardware'}
      end
      it 'should select the Search Results template for rendering' do
        response.should render_template('search_tmdb')
      end
      it 'should make the TMDb search results available to that template' do
        assigns(:movies).should == @fake_results
      end
    end
  end
end