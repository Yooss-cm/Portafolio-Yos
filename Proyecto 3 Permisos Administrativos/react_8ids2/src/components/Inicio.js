import React from 'react'
import Menu from "./Menu";
import Carousel from 'react-bootstrap/Carousel';

const Inicio = () => {  

    return(
        <div className="container mt-5" >
            <Menu />
            <br></br>
            <Carousel data-bs-theme="dark">
            <Carousel.Item>
                <img
                style={{height:'75vh'}}
                className="d-block w-100"
                src="./images/02.png"
                alt="First slide"
                />
                <Carousel.Caption>
                <h5
                style={{color:'white'}}
                >UTTEC</h5>
                <p
                style={{color:'white'}}
                >Atardecer de la UTTEC</p>
                </Carousel.Caption>
            </Carousel.Item>
            <Carousel.Item>
                <img
                style={{height:'75vh'}}
                className="d-block w-100"
                src="./images/03.png"
                alt="Second slide"
                />
                <Carousel.Caption>
                <h5
                style={{color:'white'}}
                >UTTEC</h5>
                <p
                style={{color:'white'}}
                >Entrada a la UTTEC</p>
                </Carousel.Caption>
            </Carousel.Item>
            <Carousel.Item>
                <img
                style={{height:'75vh'}}
                className="d-block w-100"
                src="./images/01.png"
                alt="Third slide"
                />
                <Carousel.Caption>
                <h5
                style={{color:'white'}}>UTTEC</h5>
                <p>El patio de la UTTEC</p>
                </Carousel.Caption>
            </Carousel.Item>
            </Carousel>
  
        </div>
    )
    
};
export default Inicio;