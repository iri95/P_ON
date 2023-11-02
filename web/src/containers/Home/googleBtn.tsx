import Image from 'next/image';
import Link from 'next/link';

import styles from './Home.module.scss';

export default function googleBtn() {
  return (
    <Link
      href="https://play.google.com/store/apps/details?id=com.wanyviny.p_on&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1"
      target="_blank"
      className={styles['google-btn']}
    >
      <Image src="/google-play-badge.png" alt="다운로드하기 Google Play" fill quality={100} objectFit="contain" />
    </Link>
  );
}
