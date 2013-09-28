require 'spec_helper'
describe MoviesController do
  describe 'List movies by director' do
    it 'should searches movies by director and render movies_by_director' do
      fake_results = mock('Movie')
      Movie.should_receive(:find_all_by_director).with('alfonze').
         and_return(fake_results)
      get :movies_by_director,{:director=>'alfonze'}
      response.should render_template :movies_by_director
    end
  end
end
