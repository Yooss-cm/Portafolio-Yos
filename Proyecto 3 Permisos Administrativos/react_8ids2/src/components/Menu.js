import React from 'react'
import { Nav, Navbar} from 'react-bootstrap'
import { Link } from "react-router-dom";
import '../components/style.css'
function Menu() {
  return (
    <Navbar expand="lg" className='bg-body-tertiary' bg="dark" data-bs-theme="dark">
      <div class="container-fluid">
          <Navbar.Brand class="navbar-brand text-white" href="#">
            <img src="./UTTECLogo.png" className='text-white' width="50"/>{' '}{' '}
            UTTEC
          </Navbar.Brand>
        {/* <Navbar.Brand className='custom-brand'><a class="navbar-brand">M E N Ú</a></Navbar.Brand> */}
        <button class="navbar-toggler bg-dark" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
        <Navbar.Toggle aria-controls='basic-navbar-nav'/>
        <Navbar.Collapse id='basic-navbar-nav'>
            <Nav className="mx-auto">
                <Nav.Link as={Link} to="/homeori"><li class="nav-item"><a class="nav-link active text-white" aria-current="page" >HOME</a></li></Nav.Link>
                <Nav.Link as={Link} to="/permisos"><li class="nav-item"><a class="nav-link active text-white" aria-current="page">PERMISOS</a></li></Nav.Link>
                <Nav.Link as={Link} to="/permiso/nuevo"><li class="nav-item"><a class="nav-link active text-white" aria-current="page">NUEVO</a></li></Nav.Link>
            </Nav>
        </Navbar.Collapse>
        </div>
    </Navbar>
  )
}


export default Menu