let express = require('express')
let app = express()
let tile_router = require('./tile_router')

let available_fractals = ['mandelbrot']
module.exports.available_fractals = available_fractals

//Middleware
app.set('view engine', 'ejs')
app.use('/assets', express.static('public'))
app.use('/tiles', tile_router)

//Router
app.get('/', (request, response) => {
    response.render('index', {fractals: available_fractals})
})

app.get('/:fractal', (req, res) => {
    if (available_fractals.includes(req.params.fractal)) {
        res.render('fractal', {fractal: req.params.fractal})
    } else {
        res.redirect('/')
    }
})

app.listen(8080)


//Repl
let repl = require('repl')
r = repl.start()
r.defineCommand('enable', (arg) => {
    if(!available_fractals.includes(arg)) {
        available_fractals.push(arg)
    }
})
r.defineCommand('disable', (arg) => {
    if(available_fractals.includes(arg)) {
        available_fractals.splice(available_fractals.indexOf(arg), 1)
    }
})
r.defineCommand('ls', () => {
    console.log('Fractales opérationnelles :')
    available_fractals.forEach((fractal) => {
        console.log('\t- ' + fractal)
    })
})