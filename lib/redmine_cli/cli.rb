module RedmineCLI
  class CLI < Thor
    register(Tasks::List, 'list', 'list [COMMAND]', 'List issues.')
    register(Tasks::Commit, 'commit', 'commit [COMMAND]', 'Commit with ticket ref.')
    register(Tasks::Time, 'time', 'time [COMMAND]', 'Worktime management.')

    map 'cm' => :commit
    map 'ci' => :commit
  end
end
