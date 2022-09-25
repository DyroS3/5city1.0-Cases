const app = new Vue({
    el: '#app',
    data: {
        rolled: 0,
        items: [
		
		],
        rolling: false,
        lastindex: 'index3',
        chest_label: 'WEAPON CASE',
		case_name: 'test',
        summary_display: 'flex',
        cases: 0,
        animDur: 8000,
        checking: false,
    },
	
    methods: {
        toggleView(items, cases, name) {
            if(items) {
                this.items = items  
				
                for(let item of this.items) {					
					item.img = `img/${item.name}.png`
                }
            }
			
            if(cases) {
                this.cases = cases
            }
			
			if(name) {
				this.case_name = name
			}
			
			start()
			if(!this.rolling) {
				this.shuffle()
			}
        },
        close() {
            this.leave()
            fetch(`https://${GetParentResourceName()}/close`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify({})
            })
        },
        openCase(id) {
            this.shuffle()
            this.cases--
            this.rolled = id - 1
            let rolled = this.items[this.rolled]
			
			console.log(rolled.name)
            let dist = Math.floor(Math.random() * (15060 - 14830) + 14830)
            document.getElementById('index65').className = 'case ' + rolled.color
            document.getElementById('index65').innerHTML = '<div class="case-img"><img src="' + rolled.img + '"></div><div class="case-bottom"><div class="case-description"><div class="case-desc">' + rolled.desc + '</div><div class="case-title">' + rolled.label + '</div></div></div><div class="case-sounder"></div>'
            this.rolling = true
            this.$refs.btn.classList.add('active')
            this.sound()
            this.$refs.items.animate([
                {left: '0px'},
                {left: '-' + dist + 'px'}
            ], {
                duration: this.animDur,
                easing: 'ease'
            })
            setTimeout(() => {
                this.$refs.items.style.left = '-' + dist + 'px'
                this.$refs.btn.classList.remove('active')
                this.rolling = false
                this.summaryFade('in')
            }, this.animDur)
        },
        shuffle(){
			if (this.$refs.items != undefined) {
				this.$refs.items.innerHTML = ""
			}
			
            for(i=0; i<100; i++){
                let randomitem = this.items[Math.floor(Math.random()*this.items.length)];
                let item = document.createElement("div");
                item.classList.add("case", randomitem.color)
                item.setAttribute('id', 'index' + i)
                item.innerHTML = '<div class="case-img"><img src="' + randomitem.img + '"></div><div class="case-bottom"><div class="case-description"><div class="case-desc">' + randomitem.desc + '</div><div class="case-title">' + randomitem.label + '</div></div></div><div class="case-sounder"></div>'
                this.$refs.items.appendChild(item)
            }
        },
        open(){
            if(this.checking == false && this.rolling == false && this.cases > 0){
                this.checking = true
                fetch(`https://${GetParentResourceName()}/openCase`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: JSON.stringify({name: this.case_name})
                }).then(res => res.json().then(response => {
                    this.checking = false
					
                    if (response.error) {
                        this.$refs.btn.animate([
                            {left: '0px'},
                            {left: '-15px'},
                            {left: '15px'},
                            {left: '0px'}
                        ], {
                            duration: 100
                        })
                    } else {
                        this.openCase(response.itemKey)
                    }
                }))
            }
            else{
                this.$refs.btn.animate([
                    {left: '0px'},
                    {left: '-15px'},
                    {left: '15px'},
                    {left: '0px'}
                ], {
                    duration: 100
                })
            }
        },
        checkCollision(elm1, elm2) {
            var elm1Rect = elm1.getBoundingClientRect();
            var elm2Rect = elm2.getBoundingClientRect();
          
            return (elm1Rect.right >= elm2Rect.left &&
                elm1Rect.left <= elm2Rect.right) &&
              (elm1Rect.bottom >= elm2Rect.top &&
                elm1Rect.top <= elm2Rect.bottom);
        },
        sound(){
            let audio = new Audio('sound.wav')
            if(this.rolling == true){
                setTimeout(() => {
                    for(let caseSounder of document.getElementsByClassName('case')) {
                        if(this.checkCollision(caseSounder, document.getElementById('arrow'))) {
                            if(caseSounder.id !== this.lastindex){
                                this.lastindex = caseSounder.id
                                audio.play();
                            }
                        }
                    }
                    this.sound()
                }, 70)
            }
        },
        summaryFade(type){
            let summary = document.getElementById('summary')
            switch(type){
                case 'in':
                    this.summary_display = 'flex'
                    summary.style.opacity = '0'
                    summary.animate([
                        {opacity: 0},
                        {opacity: 1},
                        ], {
                            duration: 200
                        }
                    )
                    setTimeout(function(){
                        summary.style.opacity = '1'
                    }, 200)
                    break
                case 'out':
                    this.$refs.items.style.left = '0px'
                    summary.style.opacity = '1'
                    summary.animate([
                        {opacity: 1},
                        {opacity: 0},
                        ], {
                            duration: 200
                        }
                    )
                    setTimeout(() => {
                        summary.style.opacity = '0'
                        this.summary_display = 'none'
                    }, 200)
                    break
            }
        },
        leave(){
            document.getElementsByTagName("BODY")[0].style.opacity = '1'
            document.getElementsByTagName("BODY")[0].animate([
                {opacity: 1},
                {opacity: 0},
                ], {
                    duration: 200
                }
            )
            setTimeout(function(){
                document.getElementsByTagName("BODY")[0].style.opacity = '0'
                document.getElementsByTagName("BODY")[0].style.display = 'none'
            }, 200)
        }
    }
})

function start(){
    document.getElementsByTagName("BODY")[0].style.display = 'block'
    document.getElementsByTagName("BODY")[0].style.opacity = '0'
    document.getElementsByTagName("BODY")[0].animate([
        {opacity: 0},
        {opacity: 1},
        ], {
            duration: 200
        }
    )
    setTimeout(function(){
        document.getElementsByTagName("BODY")[0].style.opacity = '1'
    }, 200)
    app.summary_display = 'none'
}

window.addEventListener('message', (event) => {
    if(event.data.type === 'toggle') {
        app.toggleView(event.data.items, event.data.cases, event.data.name);
    }
})

window.onkeydown = function(event) {
    if (event.keyCode == 27) {
        app.close()
    }
};