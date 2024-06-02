FROM ubuntu

RUN apt-get update
RUN apt-get install ruby --assume-yes
RUN gem install sinatra
RUN gem install rackup

COPY main.rb main.rb

CMD ["ruby", "/main.rb"]