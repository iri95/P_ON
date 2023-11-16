// import { useScroll, useTransform, motion } from 'framer-motion';
import { useRef } from 'react';
import Image from 'next/image';
// import { stylesWithCssVar } from './motion';

import styles from './Home.module.scss';

interface Props {
  id: number;
  tag: string;
  image_alt: string[];
  image_src: string[];
  title: string[];
  description: string[];
}

interface PageProps {
  data: Props[];
}

// const animationOrder = {
//   initial: 0,
//   fadeInEnd: 0.15,
//   showParagraphOne: 0.25,
//   hideParagraphOne: 0.3,
//   showParagraphTwoStart: 0.35,
//   showParagraphTwoEnd: 0.4,
//   hideParagraphTwo: 0.5,
//   showLoadingScreenStart: 0.53,
//   showLoadingScreenEnd: 0.58,
//   createBranchStart: 0.65,
//   createBranchEnd: 0.7,
//   createBranchFadeInStart: 0.78,
//   createBranchFadeInEnd: 0.85,
//   endTextFadeInStart: 0.95,
//   endTextFadeInEnd: 1,
// };

export default function SectionPage({ data }: PageProps) {
  const targetRef = useRef<HTMLDivElement | null>(null);
  // const { scrollYProgress } = useScroll({
  //   target: targetRef,
  //   offset: ['start end', 'end end'],
  // });

  // const opacity = useTransform(
  //   scrollYProgress,
  //   [
  //     animationOrder.initial,
  //     animationOrder.fadeInEnd,
  //     animationOrder.createBranchEnd,
  //     animationOrder.endTextFadeInStart,
  //   ],
  //   [0, 1, 1, 0],
  // );
  // const scale = useTransform(
  //   scrollYProgress,
  //   [
  //     animationOrder.initial,
  //     animationOrder.fadeInEnd,
  //     animationOrder.showLoadingScreenEnd,
  //     animationOrder.createBranchStart,
  //   ],
  //   [1, 1, 1, 0.5],
  // );
  // const x = useTransform(
  //   scrollYProgress,
  //   [
  //     animationOrder.initial,
  //     animationOrder.showParagraphOne,
  //     animationOrder.hideParagraphOne,
  //     animationOrder.showParagraphTwoStart,
  //     animationOrder.showParagraphTwoEnd,
  //     animationOrder.hideParagraphTwo,
  //     animationOrder.showLoadingScreenStart,
  //     animationOrder.showLoadingScreenEnd,
  //     animationOrder.createBranchEnd,
  //   ],
  //   ['50%', '50%', '55%', '-50%', '-50%', '-55%', '0%', '0%', '-27%'],
  // );

  // const loadingScreenOpacity = useTransform(
  //   scrollYProgress,
  //   [animationOrder.showLoadingScreenStart, animationOrder.showLoadingScreenEnd],
  //   [0, 1],
  // );
  // const loadingScreenX = useTransform(
  //   scrollYProgress,
  //   [animationOrder.createBranchStart, animationOrder.createBranchEnd],
  //   ['0%', '27%'],
  // );
  // const loadingScreenscale = useTransform(
  //   scrollYProgress,
  //   [animationOrder.createBranchStart, animationOrder.createBranchEnd],
  //   [1, 0.5],
  // );

  // const paragraph1Opacity = useTransform(
  //   scrollYProgress,
  //   [animationOrder.fadeInEnd + 0.02, animationOrder.showParagraphOne, animationOrder.hideParagraphOne],
  //   [0, 1, 0],
  // );
  // const paragraph1TranslateY = useTransform(
  //   scrollYProgress,
  //   [animationOrder.fadeInEnd + 0.02, animationOrder.showParagraphOne, animationOrder.hideParagraphOne],
  //   ['4rem', '0rem', '-4rem'],
  // );

  // const paragraph2Opacity = useTransform(
  //   scrollYProgress,
  //   [animationOrder.showParagraphTwoStart, animationOrder.showParagraphTwoEnd, animationOrder.hideParagraphTwo],
  //   [0, 1, 0],
  // );
  // const paragraph2TranslateY = useTransform(
  //   scrollYProgress,
  //   [animationOrder.showParagraphTwoStart, animationOrder.showParagraphTwoEnd, animationOrder.hideParagraphTwo],
  //   ['4rem', '0rem', '-4rem'],
  // );

  // const newBranchOpacity = useTransform(
  //   scrollYProgress,
  //   [animationOrder.createBranchFadeInStart, animationOrder.createBranchFadeInEnd],
  //   [0, 1],
  // );

  // const endTextOpacity = useTransform(
  //   scrollYProgress,
  //   [animationOrder.endTextFadeInStart, animationOrder.endTextFadeInEnd],
  //   [0, 1],
  // );

  // const endTexty = useTransform(
  //   scrollYProgress,
  //   [animationOrder.endTextFadeInStart, animationOrder.endTextFadeInEnd],
  //   ['4rem', '0rem'],
  // );

  // const position = useTransform(scrollYProgress, (pos) => (pos >= 1 ? 'relative' : 'fixed'));

  // const avatarOpacity = useTransform(scrollYProgress, (pos) => (pos >= animationOrder.fadeInEnd ? 1 : 0));

  return (
    <section ref={targetRef}>
      {data.map((item: Props) => (
        <section key={item.id} className={`${styles.section} ${styles.service}`} id={`section${item.id}`}>
          <div className={styles['text-container']}>
            <div className={styles.tag}>
              <p>{item.tag}</p>
            </div>

            {item.title.map((t_item) => (
              <p className={styles.title} key={t_item}>
                {t_item}
              </p>
            ))}

            {item.description.map((d_item) => (
              <p className={styles.description} key={d_item}>
                {d_item}
              </p>
            ))}
          </div>

          <div className={styles['image-container']}>
            <div className={styles.screen}>
              <Image src={item.image_src[0]} alt={item.image_alt[0]} objectFit="contain" fill quality={100} priority />
            </div>
            <div className={styles.screen}>
              <Image src={item.image_src[1]} alt={item.image_alt[1]} objectFit="cover" fill quality={100} priority />
            </div>
          </div>
        </section>
      ))}
    </section>
  );
}
