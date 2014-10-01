buzzwords = ['Paradigm shift', 'Leverage', 'Pivoting', 'Turn-key', 'Streamlininess', 'Exit strategy', 'Synergy', 'Enterprise', 'Web 2.0'] 
buzzword_counts = Hash.new({ value: 0 })

SCHEDULER.every '1m', :first_in => 0 do
  recent_users = User.sort(:created_at.desc).limit(10)
  buzzword_counts = Hash.new({ value: 0 })

  recent_users.each do |user|
   buzzword_counts[user] = {label: user.first_name  ,value: user.created_at.strftime("%Y-%m-%d %H:%M")}
  end

  send_event('buzzwords', { items: buzzword_counts.values })
end
