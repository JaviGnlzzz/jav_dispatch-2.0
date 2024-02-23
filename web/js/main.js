const app = new Vue({
    el: '#app',
    data: {
        dispatch: {
            open: false,
            cursor: false,

            player: {},

            options: {
                controls: [
                    { label: 'RAD', value: 'rad', disabled: true },
                    { label: 'C-37', value: 'rad', disabled: false },
                    { label: '320', value: 'rad', disabled: false },
                    { label: 'TEM', value: 'rad', disabled: false },
                    { label: 'PANIC', value: 'rad', disabled: false },
                ],
            },

            data: {
                calls: {
                    index: 1,
                    data: {},
                    total: 0
                },

                channel: {

                    loading: false,

                    channelOn: {},

                    openAllowed: false,

                    allowed: [],

                    messages: [],

                    icons: [
                        { name: 'police', icon: 'fa-solid fa-user-police', color: 'var(--pol-blue)' },
                        { name: 'ambulance', icon: 'fa-solid fa-user-nurse', color: 'var(--ambulance-red)' },
                    ]
                },

                other: {
                    distance: '- - -',
                    currentAlert: '- - -',
                }
            }
        }
    },
    methods: {
        post: function (url, data, cb) {
            $.post(`https://${GetParentResourceName()}/${url}`, JSON.stringify(data) || JSON.stringify({}), cb || function () { });
        },

        getItemClasses(item) {
            const classes = [];

            if (!this.dispatch.cursor) {
                classes.push('hideOptions');
            }

            if (item.disabled) {
                classes.push('disabled');
            }

            return classes.join(' ');
        },

        autoResizeWith(name) {
            const element = document.querySelector(name);
            const text = element.textContent;

            const tempElement = document.createElement("div");
            tempElement.style.cssText = "display: inline-block; visibility: hidden; white-space: nowrap;";
            tempElement.innerText = text;

            document.body.appendChild(tempElement);

            const vwWidth = (tempElement.offsetWidth / window.innerWidth) * 100;

            element.style.width = vwWidth + "vw";

            tempElement.remove();
        },

        clickControl(control, index) {

            if (!control) return

            this.post('controlAction', { control: control, index: index }, (controls) => {
                this.dispatch.options.controls = controls;
            })
        },

        getCurrentChannelIcon(job) {
            const icon = this.dispatch.data.channel.icons.find((item) => item.name === job);
            return icon ? icon.icon : 'fa-solid fa-user-magnifying-glass';
        },

        getCurrentChannelColor(job) {
            const icon = this.dispatch.data.channel.icons.find((item) => item.name === job);
            return icon ? icon.color : 'var(--undefined-grey)';
        },

        scrollToBottomChannel() {
            const messageContainer = document.querySelector('.dispatch-channel');

            messageContainer.scrollTop = messageContainer.scrollHeight;
        },

        enterAllowedChannels() {
            this.dispatch.data.channel.openAllowed = !this.dispatch.data.channel.openAllowed;
        },

        enterNewChannel(channel) {
            this.post('enterChannel', { index: channel })

            this.dispatch.data.channel.openAllowed = false;
        },

        clickLocationButton(coords) {
            this.post('sendLocation', { coords: coords })
        },

        handleMessage(event) {
            const { type, data, channelOn, player } = event.data;

            if (type == 'update:player') {
                this.dispatch.player = player
            };

            if (type == 'show:main') {
                this.dispatch.open = true;
                this.dispatch.data.calls.data = data.call;
                this.dispatch.data.calls.index = data.call.id || 0;
                this.dispatch.data.calls.total = data.totalCalls;
                this.dispatch.options.controls = data.controls;
                this.dispatch.data.channel.allowed = data.channels.allowed;

                if (data.channels.channelOn.length != 0) {
                    this.dispatch.data.channel.messages = data.channels.channelOn.data
                };

                this.dispatch.data.channel.channelOn = data.channels.channelOn

                this.scrollToBottomChannel()
                this.autoResizeWith('.dispatch-current-calls')
            };

            if (type == 'new:call') {

                if (!this.dispatch.open) this.dispatch.open = true;

                this.dispatch.data.calls.data = data.call;
                this.dispatch.data.calls.index = data.call.id || 0;
                this.dispatch.data.calls.total = data.totalCalls;
                this.dispatch.options.controls = data.controls;

                if (data.channels.channelOn.length != 0) {
                    this.dispatch.data.channel.messages = data.channels.channelOn.data
                };

                this.dispatch.data.channel.channelOn = data.channels.channelOn

                this.autoResizeWith('.dispatch-current-calls')
            };

            if (type == 'move:call') {
                const containerData = document.querySelectorAll('.dispatch-calls-data-text, .call-index');

                this.autoResizeWith('.dispatch-current-calls');

                let animation = false;

                if (!animation) {
                    animation = true;

                    containerData.forEach(element => {
                        element.classList.remove('show-data-call');
                        element.classList.add('hide-data-call');
                    });

                    setTimeout(() => {
                        containerData.forEach(element => {
                            element.classList.remove('hide-data-call');
                            element.classList.add('show-data-call');
                        });

                        animation = false;

                        this.dispatch.data.calls.data = data.call;
                        this.dispatch.data.calls.index = data.call.id || 0;
                        this.dispatch.data.calls.total = data.totalCalls;
                    }, 250);
                }
            };

            if (type == 'hide:main') {
                this.dispatch.open = false;
            };

            if (type == 'enable:cursor') {
                this.dispatch.cursor = true;
            };

            if (type == 'disable:cursor') {
                this.dispatch.cursor = false;
            };

            if (type == 'update:channelOn') {

                if (channelOn.length != 0) {
                    this.dispatch.data.channel.messages = channelOn.data
                };

                this.dispatch.data.channel.channelOn = channelOn

                setTimeout(() => {
                    this.scrollToBottomChannel()
                }, 200)
            };

            if (type === 'location:selected') {
                const containerCalls = document.querySelector('.dispatch-calls-data');

                containerCalls.style.transition = 'background-color .25s';
                containerCalls.style.backgroundColor = 'var(--location-green)';

                setTimeout(() => {
                    containerCalls.style.backgroundColor = 'rgba(128, 128, 128, 0.075)';
                }, 500);
            }

        },

        handleKeyDown(event) {
            if (event.keyCode === 27) {
                this.post('cursor')
            }
        }
    },
    mounted() {
        window.addEventListener('message', this.handleMessage)

        window.addEventListener('keydown', this.handleKeyDown);

        setInterval(() => {

            if (this.dispatch.data.calls.data != '' && this.dispatch.open) {

                const coords = this.dispatch.data.calls.data.other.coords;

                this.post('getDistanceToCoords', {
                    coords: {
                        x: coords.x,
                        y: coords.y,
                        z: coords.z
                    }
                }, (distance) => {
                    distance = Math.round(distance);
                    this.dispatch.data.other.distance = distance.toString().length < 4 ? distance + ' M' : (distance / 1000).toFixed(2) + ' KM';
                })
            };

        }, 1000);

        setInterval(() => {
            if (this.dispatch.data.calls.data != '' && this.dispatch.open) {
                this.autoResizeWith('.distance-call')
            }
        }, 100)
    },
})