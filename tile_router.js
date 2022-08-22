const express = require('express');
const fs = require('fs')
const childProcess = require('child_process')
const router = express.Router();
const server = require('./server')


router.get('/', (req, res) => {
    res.redirect('/')
})

router.get('/:fractal/:z/:x/:y', (req, res) => {
    if(req.params.fractal === undefined || req.params.z === undefined || req.params.x === undefined || req.params.y === undefined) {
        console.log('Invalid parameters')
        res.redirect('/')
    } else {
        let fractal = req.params.fractal
        let z = req.params.z
        let x = req.params.x
        let y = req.params.y

        if (!server.available_fractals.includes(fractal)) {
            console.log('Trying to access to ' + fractal)
            res.status(403).end()
        } else {
            let fractalFolder = 'tiles/' + fractal + '/'
            let tileFile = fractalFolder + 'tiles/' + z + '.' + x + '.' + y + '.png'
            fs.access(tileFile, fs.constants.R_OK, (err) => {
                if (err) {
                    console.log('Génération de ' + tileFile)
                    childProcess.execFile('./generate', [z, x, y], {cwd: fractalFolder}, (err, stdout, stderr) => {
                        fs.access(tileFile, fs.constants.R_OK, (err) => {
                            if (err) {
                                console.error('Erreur dans la génération de ' + tileFile)
                                res.status(404).end()
                            } else {
                                console.log('Fichier ' + tileFile + ' généré avec succès!')
                                res.sendFile(tileFile, {root: __dirname})
                            }
                        })
                    })
                } else {
                    res.sendFile(tileFile, {root: __dirname})
                }
            })
        }
    }
})


module.exports = router
