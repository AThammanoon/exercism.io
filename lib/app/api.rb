class ExercismApp < Sinatra::Base

  get '/api/v1/user/assignments/current' do
    unless params[:key]
      halt 401, {error: "Please provide API key"}.to_json
    end

    assignments = Assignments.new(params[:key])

    pg :assignments, locals: {assignments: assignments.current}
  end

  post '/api/v1/user/assignments' do
    request.body.rewind
    data = request.body.read
    if data.empty?
      halt 400, "Must send key and code as json."
    end
    data = JSON.parse(data)
    user = User.find_by(key: data['key'])
    halt 401, "Unable to identify user" unless user

    attempt = Attempt.new(user, data['code'], data['path']).save

    status 201
    pg :attempt, locals: {submission: attempt.submission}
  end

  get '/api/v1/user/assignments/next' do
    unless params[:key]
      halt 401, {error: "Please provide API key"}.to_json
    end

    assignments = Assignments.new(params[:key])

    pg :assignments, locals: {assignments: assignments.current}
  end
end
