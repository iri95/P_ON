'use client';

import { useRef } from 'react';
import { motion, useScroll, useTransform, MotionValue } from 'framer-motion';
import Image from 'next/Image';
import styles from './Home.module.scss';
import Section1 from './Section1';

function useParallax(value: MotionValue<number>, distance: number) {
  return useTransform(value, [0, 1], [-distance, distance]);
}

export default function Index() {
  const ref = useRef(null);
  const { scrollYProgress } = useScroll({ target: ref });
  const y = useParallax(scrollYProgress, 300);

  return (
    <div className={`${styles.scroll}`}>
      <div className={styles.section} id="section1">
        <Section1 />
      </div>

      <section className={`${styles.section} ${styles.section2} ${styles.service}`} id="section2">
        <motion.div className={styles['text-container']} style={{ y }}>
          소개
        </motion.div>
        <div className={styles['image-container']} ref={ref}>
          <div className={styles.screen}>{/* <Image /> */}</div>
        </div>
      </section>

      <div className={`${styles.section} ${styles.lastSection}`} />
    </div>
  );
}
