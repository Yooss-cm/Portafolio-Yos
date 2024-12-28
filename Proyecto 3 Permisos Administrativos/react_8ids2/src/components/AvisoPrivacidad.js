import React from 'react'
import '../components/avisoprivacidad.css' 

const AvisoPrivacidad = () => {  
  return (
    <div className='body_new'>
        <div className="container_dos">
        <h1 className="h1m">Aviso de Privacidad - Universidad Tecnológica de Tecámac</h1>
        
        <p className='p_m'>En la Universidad Tecnológica de Tecámac "UTTEC", nos comprometemos a proteger la privacidad y la seguridad de la información personal de nuestros usuarios. Al utilizar nuestra plataforma para administrar permisos de faltas de profesores, usted acepta los términos de este aviso de privacidad.</p>
        
        <h2>Recopilación de Información</h2>
        <p className='p_m'>Para utilizar nuestros servicios, es posible que recopilemos información personal como su correo electrónico y contraseña. Esta información es necesaria para autenticar su identidad y garantizar la seguridad de su cuenta.</p>
        
        <h2>Uso de la Información</h2>
        <p className='p_m'>La información recopilada se utilizará únicamente con el propósito de administrar los permisos de faltas de profesores en nuestra plataforma. No compartiremos su información personal con terceros sin su consentimiento, excepto en los casos que lo requiera la ley.</p>
        
        <h2>Seguridad de la Información</h2>
        <p className='p_m'>Implementamos medidas de seguridad técnicas y organizativas para proteger la información personal contra el acceso no autorizado, la divulgación, la alteración o destrucción.</p>
        
        <h2>Contacto</h2>
        <p className='p_m'>Si tiene alguna pregunta o inquietud sobre nuestra política de privacidad, no dude en ponerse en contacto con nosotros a través de <a className='aa' href="mailto:privacidad@uttec.mx">uttecamac@uttec.mx</a>.</p>
        
        <p className='p_m'>Última actualización: 01/Abril/2024</p>
        </div>
      </div>
    )
    
  };
export default AvisoPrivacidad;