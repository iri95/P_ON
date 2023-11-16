import Image from 'next/image';
import styles from './Home.module.scss';
import GoogleBtn from './downloadBtn';

export default function SectionEnd() {
  return (
    <div className={styles['end-container']}>
      <div className={styles.image}>
        <Image
          src="/Pinkys.png"
          alt="핑키 배경"
          fill
          style={{ objectFit: 'cover', objectPosition: 'center' }}
          quality={100}
          priority
        />
      </div>
      <div className={styles.title}>
        <p>
          지금
          <span className={styles.logo}>
            <Image priority src="/P_ON.png" alt="P:ON 로고" style={{ objectFit: 'contain' }} fill quality={100} />
          </span>
          에서
        </p>
        <p>
          <span>약속의 순간</span>을 더욱 값진 <span>추억</span>으로 만들어보세요!
        </p>
      </div>
      <GoogleBtn />
    </div>
  );
}
