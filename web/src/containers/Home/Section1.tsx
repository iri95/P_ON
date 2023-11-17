import Image from 'next/image';
import { useScroll, useTransform, motion } from 'framer-motion';
import { useRef } from 'react';
import styles from './Home.module.scss';
import GoogleBtn from './downloadBtn';

export default function Section1() {
  const targetRef = useRef<HTMLDivElement | null>(null);
  const { scrollYProgress } = useScroll({
    target: targetRef,
    offset: ['end end', 'end start'],
  });
  const opacity = useTransform(scrollYProgress, [0, 0.5], [1, 0]);
  const position = useTransform(scrollYProgress, (pos) => (pos >= 1 ? 'relative' : 'fixed'));

  return (
    <motion.section style={{ opacity }} ref={targetRef} className={`${styles.section}`}>
      <motion.div style={{ position }} className={styles.section1}>
        <div className={styles.screenshots}>
          <div className={styles.screen}>
            <Image
              src="/main/main1.png"
              alt="PON스플래시"
              style={{ objectFit: 'contain' }}
              fill
              quality={100}
              priority
            />
          </div>
          <div className={`${styles.screen}`}>
            <Image src="/main/main2.png" alt="PON홈화면" style={{ objectFit: 'contain' }} fill quality={100} priority />
          </div>
          <div className={`${styles.screen}`}>
            <Image src="/main/main3.png" alt="PON채팅방" style={{ objectFit: 'contain' }} fill quality={100} priority />
          </div>
        </div>

        <div className={styles.text}>
          <div className={styles.title}>
            <Image src="/P_ON.png" alt="P:ON 로고" style={{ objectFit: 'contain' }} fill quality={100} priority />
          </div>
          <p className={styles.description}>
            <span>약속의 시작</span>을 완벽하게 연결합니다!
          </p>
          <GoogleBtn />
        </div>
      </motion.div>
    </motion.section>
  );
}
