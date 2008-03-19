var Slice = Class.create({
  initialize: function(options) {
    this.id = options.id;
    this.url = 'http://localhost:4000/slices/' + this.id;
    this.image = new Element('img', { src: options.image_url, style: 'position: fixed' });
    this.updater = new PeriodicalExecuter(this.update.bind(this), 1.25);
  },
  finish: function() {
    this.image.remove();
    this.updater.stop();
  },
  update: function() {
    new Ajax.Request(this.url + '.json', { 
      method: 'get',
      onSuccess: function(response) {
        var slice = response.responseJSON;
        this.image.src = slice.image_url;
        if (slice.packaged) {
          this.updater.stop();
        }
        
      }.bind(this)
    });
  }
});

var Conveyor = Class.create({
  initialize: function(element) {
    this.element = $(element);
    this.updater = new PeriodicalExecuter(this.update.bind(this), 0.5);
  },
  update: function() {
    new Ajax.Request('http://localhost:4000/slices.json', {
      method: 'get',
      asynchronous: false,
      parameters: { limit: 1 },
      onSuccess: function(response) {
        var slices = response.responseJSON;
        slices.each(function(sliceAttributes) {
          var slice = new Slice(sliceAttributes);
          slice.image.setStyle({top: (this.top() + 10) + 'px', left: (this.left() + this.width() + 100) + 'px'});
          this.element.insert({before:slice.image});
          new Effect.Move(slice.image, { x: this.left() - 50, y: this.top() + 110, duration: 4, mode: 'absolute', transition: Effect.Transitions.linear, afterFinish: function() { slice.finish(); } });
        }.bind(this));
      }.bind(this)
    });
  },
  top: function() {
    return this.element.offsetTop;
  },
  left: function() {
    return this.element.offsetLeft;
  },
  width: function() {
    return this.element.offsetWidth;
  },
  height: function() {
    return this.element.offsetHeight;
  }
});
