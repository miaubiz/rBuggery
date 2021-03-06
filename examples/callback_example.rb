require 'buggery'

# Toy example, to demonstrate the use of event callbacks, by registering a
# callback for LoadModule

debug_client=Buggery.new

lm_callback=lambda {|args|
  # args receives a hash, keys and values taken from the callback definition
  # in dbgeng.h, but converted to snake_case.
  puts(
  "Module Load:
  Name: #{args[:image_name].downcase} 
  Base Address: #{"%8.8x" % args[:base_offset]} 
  Size: 0x#{"%x" % args[:module_size]}"
  )
  0 # DEBUG_STATUS_NO_CHANGE
}

debug_client.event_callbacks.add( :load_module=>lm_callback )

debug_client.create_process "notepad.exe"
loop do
  # It's not a bad idea to use a timeout here, because ^C won't interrupt
  # a #wait_for_event( -1 ).
  debug_client.wait_for_event 10 # msec
  break unless debug_client.has_target?
end

