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
    it 'should flash message & redirect to index if nil director' do
      get :movies_by_director,{:movie_title=>'Testing'}
      flash[:notice].should eq("'Testing' has no director info")
      response.should redirect_to(action: 'index')
    end
  end
  describe 'Extract valid movie classifications' do
    it 'should return the range of ratings' do
       Movie.all_ratings.should  == %w(G PG PG-13 NC-17 R)
     end

  end
  describe 'show movies' do
    it 'should find the specified movie' do
      fake_results = mock('Movie')
      Movie.should_receive(:find).with("1").and_return(fake_results)
      get :show,{:id=>1}
      response.should render_template :show
    end
  end
  describe 'Edit movie' do
    it 'should edit the movie' do
      fake_results=mock('Movie')
       Movie.should_receive(:find).with("1").and_return(fake_results)
       get :edit,{:id=>1}
       response.should render_template :edit
    end
  end
  describe 'Update Movie' do
    it 'should find the movie and update the attributes' do
      fake_results=mock_model('Movie')
      fake_results.stub(:title).and_return('Hi')
      fake_results.stub(:update_attributes!).with({'director'=>'fred','title'=>'Hi'}).and_return(true)
      Movie.should_receive(:find).with("7").and_return(fake_results)
      put :update,:id=>7,:movie=>{:director=>'fred',:title=>'Hi'}
      flash[:notice].should eq('Hi was successfully updated.')
      response.should redirect_to(fake_results)
    end
  end
  describe 'Create Movie' do
    it 'should create the movie' do
      fake_results=mock_model('Movie')
      fake_results.stub(:title).and_return('Hi')
      Movie.should_receive(:create!).with({'director'=>'fred','title'=>'Hi'}).and_return(fake_results)
      get :create,:id=>7,:movie=>{:director=>'fred',:title=>'Hi'}
      flash[:notice].should eq('Hi was successfully created.')
      response.should redirect_to(action: 'index')
    end
  end


  describe 'Destroy Movie' do
    it 'Should delete the move and flash a message' do
       fake_results=mock('Movie')
       fake_results.stub(:destroy).and_return(true)
       fake_results.stub(:title).and_return('Testing')
       Movie.should_receive(:find).with("1").and_return(fake_results)
       get :destroy,{:id=>1}
       flash[:notice].should eq("Movie 'Testing' deleted.")
       response.should redirect_to(action: 'index')
    end
  end

  describe 'Index List' do
    context 'when no session settings' do
      before(:each) do
        session.clear
        Movie.should_receive(:all_ratings).and_return(%w(G PG PG-13 NC-17 R))
      end
      it 'If there are no params then default all catergories' do
        fake_results=mock_model('Movie')
        Movie.should_receive('find_all_by_rating').with(%w(G PG PG-13 NC-17 R),nil).and_return(fake_results)
        get :index
        response.should render_template :index
      end
      it 'should sort by title if sort=>title' do
        get :index,{:sort=>'title'}
        session[:sort].should eq('title')
        response.should redirect_to(:sort=>'title',:ratings=>{'G'=>'G','PG'=>'PG','PG-13'=>'PG-13','NC-17'=>'NC-17','R'=>'R'})
      end
      it 'should sort by release data if sort=>release_date' do
        get :index,{:sort=>'release_date'}
        session[:sort].should eq('release_date')
        response.should redirect_to(:sort=>'release_date',:ratings=>{'G'=>'G','PG'=>'PG','PG-13'=>'PG-13','NC-17'=>'NC-17','R'=>'R'})
      end
      it 'should restrict by selected ratings' do
        get :index,{:ratings=>{'G'=>'G','PG'=>'PG'}}
        session[:ratings].should eq({'G'=>'G','PG'=>'PG'})
        response.should redirect_to(:ratings=>{'G'=>'G','PG'=>'PG'})
        
      end
    end
    context 'search session settings' do
      before(:each) do
        Movie.should_receive(:all_ratings).and_return(%w(G PG PG-13 NC-17 R))
        session[:ratings]={'G'=>'G','PG'=>'PG','PG-13'=>'PG-13','NC-17'=>'NC-17','R'=>'R'}
        session[:sort]='title'
      end
      it 'If there are no params then default all catergories' do
        fake_results=mock_model('Movie')
        get :index
        response.should redirect_to(:sort=>'title',:ratings=>{'G'=>'G','PG'=>'PG','PG-13'=>'PG-13','NC-17'=>'NC-17','R'=>'R'})
      end
      it 'should sort by title if sort=>title' do
        get :index,{:sort=>'title'}
        session[:sort].should eq('title')
        response.should redirect_to(:sort=>'title',:ratings=>{'G'=>'G','PG'=>'PG','PG-13'=>'PG-13','NC-17'=>'NC-17','R'=>'R'})
      end
      it 'should sort by release data if sort=>release_date' do
        get :index,{:sort=>'release_date'}
        session[:sort].should eq('release_date')
        response.should redirect_to(:sort=>'release_date',:ratings=>{'G'=>'G','PG'=>'PG','PG-13'=>'PG-13','NC-17'=>'NC-17','R'=>'R'})
      end
      it 'should restrict by selected ratings' do
        get :index,{:ratings=>{'G'=>'G','PG'=>'PG'}}
        session[:ratings].should eq({'G'=>'G','PG'=>'PG','PG-13'=>'PG-13','NC-17'=>'NC-17','R'=>'R'})
        response.should redirect_to(:ratings=>{'G'=>'G','PG'=>'PG'},:sort=>'title')
      end
    end
  end

end
