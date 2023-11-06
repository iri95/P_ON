// 'use client';

// import { motion } from 'framer-motion';
import styles from './Home.module.scss';
import Section1 from './Section1';
import Section2 from './Section2';

export default function index() {
  return (
    <div className={`${styles.scroll}`}>
      <div className={styles.section} id="section1">
        <Section1 />
      </div>
      <div className={styles.section} id="section2">
        <Section2 />
      </div>
      <div className={styles.section}>
        <div id="section3">
          <Section2 />
        </div>
      </div>

      <div className={styles.section} id="section4">
        4
      </div>
      <div className={`${styles.section} ${styles.lastSection}`} />
    </div>
  );
}
