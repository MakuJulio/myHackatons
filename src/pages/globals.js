import Head from 'next/head'
import 'bulma/css/bulma.css'
import styles from '../styles/Globals.module.css'
import Web3 from 'web3'

const Globals = () => {
    
    //window.ethereum
    const connectWalletHandler = () => {
        alert('connect wallet');
    }

    return(
        <div className={styles.main}>
            <Head>
                <title>Globals DApp</title>
                <meta name="description" content="Globals token" />
            </Head>            
            <nav className="navbar mt-4 mb-4">
                <div className="container">
                    <div className="navbar-brand">
                        <h1>Globals DApp</h1>
                    </div>
                    <div className="navbar-end">
                        <button onClick={connectWalletHandler} className="button is-primary">Connect Wallet</button>
                    </div>
                </div>
            </nav>
            <section>
                <div className='container'>
                    <p>placeholder text</p>
                </div>
            </section>
        </div>
    )
}

export default Globals