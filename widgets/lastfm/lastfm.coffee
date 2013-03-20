class Dashing.lastfm extends Dashing.Widget

  ready: ->
    status = $(@node).find('p.status')
    if status.html() == 'ok'
      status.remove()

    console.log( 'LastFM is ready' );

  onData: (data) ->
    # Handle incoming data
    # You can access the html node of this widget with `@node`
    # $(@node).fadeOut().fadeIn()
    alert data
