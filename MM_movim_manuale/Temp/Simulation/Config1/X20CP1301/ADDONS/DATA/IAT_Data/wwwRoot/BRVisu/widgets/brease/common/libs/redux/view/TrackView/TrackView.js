define(function () {

    'use strict';

    var TrackView = function (props, parent, self) {
        if (self === undefined) {
            this.create(props, parent);
            this.render(props);
            return this;
        } else {
            self.render(props);
            return self;
        }
    };

    var p = TrackView.prototype;

    p.create = function (props, parent) {
        if (props.additionalId !== undefined) {
            this.id = parent[0].id + '_TrackView_' + props.additionalId;
        } else {
            this.id = parent[0].id + '_TrackView';
        }

        this.el = $('<div id="' + this.id + '"></div>');
        this.el[0].classList.add('TrackView');

        if (props.additionalClass !== '' || props.additionalClass !== undefined) {
            this.el[0].classList.add(props.additionalClass);
        }
        parent[0].appendChild(this.el[0]);
    };

    p.render = function render(props) {
        this.el[0].style.height = props.height + 'px';
        this.el[0].style.left = props.left + 'px';
        this.el[0].style.top = props.top + 'px';
        this.el[0].style.width = props.width + 'px';
    };

    p.dispose = function dispose() {

    };

    return TrackView;

});
