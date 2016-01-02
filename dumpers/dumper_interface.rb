require_relative '../lib/util'

# To create a custom dumper:
# * Create a subdirectory in this directory named after your dumper
# * Create a file called dumper.rb in the new directory
# * Require this file: require_relative '../dumper_interface'
# * Declare a class called Dumper, inheriting from DumperInterface
# * Implement one or more of the functions listed below (at least dump_msg)

# Notes:
# * lib/util.rb exports some useful helpers. For example get_backup_dir returns
#   the output basedir path
# * The same Dumper instance will be used for all dialogs in a backup session
# * $config contains a hash of options parsed from the configuration file
#   (which is possibly interesting for custom dumper-specific options)

class DumperInterface

  # Will be called before backing up the first dialog
  # Can be used for initialization
  def start_backup
    nil
  end

  # Will be called just before dumping a dialog's messages
  def start_dialog(dialog, progress)
    # dialog: Hash, progress: DumpProgress
    nil
  end

  # Will be called before each message to dump, to determine whether it is new
  # enough to back up
  # This default makes sense in simple cases, override for advanced custom logic
  def msg_fresh?(msg, progress)
    # msg: Hash, progress: DumpProgress
    !progress.last_id || msg['id'] > progress.last_id
  end

  # Will be called for each message to dump (from newest to oldest)
  # See the python binding documentation to get an idea of the msg attributes:
  # https://github.com/vysheng/tg/blob/master/README-PY.md#attributes-1
  # Returning boolean false causes an early abort (skips to the next dialog)
  def dump_msg(dialog, msg)
    # dialog, msg: Hash
    raise 'dump_msg must be implemented'
  end

  # Will be called just after dumping a dialog's messages
  # Optionally return a hash with state information that will be saved as
  # custom progress data
  # dialog: Hash
  def end_dialog(dialog)
    # dialog: Hash
    nil
  end

  # Will be called after backing up the last dialog
  # Can be used for cleanup
  def end_backup
    nil
  end

end
